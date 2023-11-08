/*
 * Program to open raw fluorescence images and standardise their format to imput them in ilastik. 
 * This is part of the CocciVol routine. If some images do not open in FIJI contact me and I can try to solve the issue.
 * 
 * Author: Laia Pasquina-Lemonche, University of Sheffield, UK (cc)
 * 			
 * Date: March 2023
 * 
 * UPDATE: Added more comments and corrected some messages that needed clarifying
 * Date: 08th November 2023
 */
 
 run("Close All");

print("     ");
print("Welcome to the program to prepare and filter the images for analysis with ilastik program");
print("    ");
print("Introduce the analysis settings and the image properties specific for your image, \n open the image first to obtain these parameters if you do not know");

  //define the variables to be chosen by the user
  channel_BF= newArray ("0","1","2","3");
  channel_F= newArray ("0","1","2","3");
  BRIGHT = newArray("YES", "NO");
  image_colour = "red";
  Background_filter = newArray("YES","NO");
  Background = 0;
  START_slice = 6;
  STOP_slice = 7;
  
  Dialog.create("Analysis settings and image properties");
  //Adds a message of brief explanation to the dialog.
  Dialog.addMessage("Here you can change the following \n text and number values, otherwise the default values will be used.");
  Dialog.addChoice("Is there a Brightfield channel:", BRIGHT);
  Dialog.addChoice("Brightfield channel (leave as 0 if no channel):", channel_BF);
  Dialog.addChoice("Fluorescence channel (C=1, select 1, C=2, select 2, etc.):", channel_F);
  Dialog.addString("Colour of your dye (type red, blue or green):", image_colour);
  Dialog.addChoice("Do you want to filter the image? (if NO is image will be left raw)", Background_filter);
  Dialog.addNumber("Which filter number you want? (usually 25 works well, if filter not required type 0)", Background);
  Dialog.addMessage("The following values used to do a Z projection of several slices from the stack. \n This Z projection will be used for analysis, \n select the START and STOP slice for your image. \n Needs optimising for each image (usually 3 slices are used in total)");
  Dialog.addNumber("Type slice to START Z projection:", START_slice);
  Dialog.addNumber("Type slice to STOP Z projection:", STOP_slice);
  Dialog.show();
  
  //Get the variables from the dialog box to be used in the program (needs to be done in order)
   BRIGHT = Dialog.getChoice();
   channel_BF = Dialog.getChoice();
   channel_F =  Dialog.getChoice();
   image_colour = Dialog.getString();
   Background_filter = Dialog.getChoice();
   Background = Dialog.getNumber();
   START_slice = Dialog.getNumber();
   STOP_slice = Dialog.getNumber();
  
print("     ");
print("Now the program opens the image, identifies the fluorescence channel \n makes the Z projection and asks you where you want to save the composite and Z projection");
print("    ");
	
open();

//Make sure the different channels are in different windows
run("Split Channels");

//Define a variable that captures the name of the image without the extension
fileName = File.nameWithoutExtension;

//Fix the problem with the images names and rename them to continue
	if(BRIGHT == "YES"){
		selectWindow("C"+channel_BF+"-"+fileName+".nd2");
		rename("BF"); // renames the selected channel to BF
		// We wish to perform area calculations on the red channel cells, as they are the (NHS ester) 
		//cell wall labelled cells and provide an accurate size profile (as opposed to the aberrations from brightfield images)
		selectWindow("C"+channel_F+"-"+fileName+".nd2");		
		rename("Red");
	
	}else if(BRIGHT == "NO"){
		selectWindow("C"+channel_F+"-"+fileName+".nd2");		
		rename("Red");
	}

//Select directory to save the composites (if any) and the Z projections as .tif
dir1 = getDirectory("Choose Directory where you want to SAVE your composites and Z projections");

// Subtract background according to user's choice (YOU can change the value of variable Background, i.e, 25) to remove fluorescent noise, 
//although 25 works well for most files. Whatever value YOU choose should be consistent across 
//correlative data sets, especially if fluorescence intensity is being analysed
if(Background_filter == "YES"){
	selectWindow("Red");
	run("Smooth", "stack");
	run("Subtract Background...", "rolling="+Background+" stack");		
}
if(BRIGHT == "YES"){
	// Creates a red and brightfield channel overlay and saves image
	run("Merge Channels...", "c1=[Red] c2=[BF] create keep");	
	save( dir1 + fileName+"_"+image_colour+"_BF_composite.tif"); 
}

//To analyse images we need to do a Z projection of several images into a single image
selectWindow("Red");
run("Z Project...", "start="+START_slice+" stop="+STOP_slice+" projection=[Max Intensity]");

selectWindow("MAX_Red");		
save( dir1 + fileName+"_Red_Z_projection.tif"); 

//split the channels because we need to enter a black and white image in ilastik to account for alternative possible colour dyes and make it generalisable
run("RGB Color");
run("Split Channels");
selectWindow("MAX_Red (red)");
//Change naem of image to be able to save the correct file for ilastik
name1 = fileName+"_ilastik";
rename(name1);


print("     ");
print("Now the program has finished, select the folder where you want to save the .png image for further ilastik analysis");
print("     ");

selectWindow(name1);
//select the directory where you want to save your images ready for ilastik
dir2 = getDirectory("Choose Directory to save .png images for ilastik");	
saveAs("png", dir2+name1);
run("Close All");

print("      ");
print("End of code for this file, click run again to do another image");
print("      ");
print("       ---------------------         ");


