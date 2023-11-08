/*
 * Program to perform calculations of Cell Volume and other measurements from ilastik output table. 
 * The result of the program is an easier to interpret table (.csv) to be put in the Results folder.
 * 
 * Author: Laia Pasquina-Lemonche, University of Sheffield, UK
 * 			
 * Date: March 2023
 * 
 * UPDATE: Added more comments and corrected some messages that needed clarifying
 * Date: 08th November 2023
 */

//Uncomment the line below to avoid seeing all the actions the system does (not recommended)
//setBatchMode(true);

run("Close All");

print("Welcome to the program to analyse data from ilastik segmentation");
print("    ");
print("Introduce the size in um from your image in the following Dialog box");

 //define the variables to be chosen by the user
  Width = 160.4;
  Height = 140.4;
  Options = newArray ("RAW","CLEAN","BOTH");
  
  Dialog.create("Image dimensions and analysis preference");
  //Adds a message of brief explanation to the dialog.
  Dialog.addMessage("Here you have to type the image dimensions in micrometers (um), \n you can get this from opening the raw data. The bigger number will correspond to Width.");
  Dialog.addNumber("Width of image (um)", Width);
  Dialog.addNumber("Height of image (um)", Height);
  Dialog.addMessage("The parameter that this program measuers are: MAJOR and MINOR diamater from the bounding BOX, \n The VOLUME from prolate spheroid, \n The CIRCULARITY (dividing the MINOR / MAJOR diamater), \n Finally, the cell classification according to cell cycle.");
  Dialog.addChoice("What type of data do you want to save?:  \n (RAW = Values from all cells // \n CLEAN = -BAD FIT- cells removed // \n BOTH = Both types of data in separete files ", Options);
  Dialog.show();
  
  //Get the variables from the dialog box to be used in the program (needs to be done in order)
   Width = Dialog.getNumber();
   Height = Dialog.getNumber();
   Options = Dialog.getChoice();
  //Cells_of_interest = Dialog.getChoice();
  // Parameter_of_interest = Dialog.getChoice();
   
print("     ");
print("Now the program asks you to open the image, \n open the export from ilastik with the different colours and white background");
print("    ");
	

//Open the image and define a variable that captures the name of the image without the extension
open();
fileName = File.nameWithoutExtension;

//Calculate pixel to um ratio
  //get information from image (this will give pixel size)
  width_pixel = getWidth;
  height_pixel = getHeight;
  //This divides the size in um by the size in pixels
  conversion= Width/width_pixel; // We will use this one for the conversion of values in the table.
  conversion2=Height/height_pixel;
  
//Change image units to um, so all values of the results table will be in um.
Stack.setXUnit("um");
run("Properties...", "channels=1 slices=1 frames=1 pixel_width="+conversion+" pixel_height="+conversion2+" voxel_depth="+conversion+"");

// Open the CSV file from the results in ilastik and treat it as a Table, get name of file.
open();
fileName_2 = File.nameWithoutExtension;

// Get the number of rows in the table to know how much data we have
nRows = Table.size;

//Define variable as arrays to allocate data from columns in the table
cell_number = newArray(nRows);
cell_cycle = newArray(nRows);
Max_BB_X = newArray(nRows);
Max_BB_Y = newArray(nRows);
Min_BB_X = newArray(nRows);
Min_BB_Y = newArray(nRows);


// Loop through the rows and store the data in different arrays
for (i = 0; i < nRows; i++) {
	
    // Get the row and column data of interest and put it in the specific variables
    cell_number[i] = Table.get("labelimage_oid", i); 
    cell_cycle[i] = Table.getString("Predicted Class", i);
	Max_BB_X[i] = Table.get("Bounding Box Maximum_0", i);
	Max_BB_Y[i] = Table.get("Bounding Box Maximum_1", i);
	Min_BB_X[i] = Table.get("Bounding Box Minimum_0", i);
	Min_BB_Y[i] = Table.get("Bounding Box Minimum_1", i);
}


//Define variables to store the major and minor radii from the "elipse fit" which is really from a bounding box but it should be the same value
Major = newArray(nRows);
Major_radi = newArray(nRows);
Minor = newArray(nRows);
Minor_radi = newArray(nRows);

// Loop through the rows and calculate Major and minor diameter of Elipse and convert the pixels into um units
for (j = 0; j < nRows; j++) {
	
	
	Axis_1=abs(Max_BB_X[j]-Min_BB_X[j]);
	Axis_2=abs(Max_BB_Y[j]-Min_BB_Y[j]);
	
	//As we don't know which one is going to be bigger than the other axis we need to account for both situations
	if(Axis_1>Axis_2){
		Which = "Axis 1 bigger than Axis 2";
		 //Calculate major radius and convert pixels into um
		 Major[j]=Axis_1*conversion;
		 Major_radi[j] = Major[j]/2;
		 
		 //Calculate minor radius and convert picels into um
		 Minor[j]= Axis_2*conversion;
		 Minor_radi[j] = Minor[j]/2;
	}else{
		Which = "Axis 2 bigger than Axis 1";
		//Calculate major radius and convert pixels into um
		 Major[j]=Axis_2*conversion;
		 Major_radi[j] = Major[j]/2;
		 
		 //Calculate minor radius and convert picels into um
		 Minor[j]= Axis_1*conversion;
		 Minor_radi[j] = Minor[j]/2;
	}
	
}


//Calculate parameters of cells
Volume = newArray(nRows);
Circularity = newArray(nRows);
//Perimiter = newArray(nRows);

for (k = 0; k < nRows; k++) {
	
	//Calculate Volume 
	Volume[k] = (4/3)*PI*Major_radi[k]*(Minor_radi[k]*Minor_radi[k]);
	//Calculate Circularity
	Circularity[k] = Minor[k]/Major[k];
	
}
//Close previous table
selectWindow(fileName_2+".csv");
run("Close");


//Create final results table with the Major diameter, Minor diameter and the volume
table1="Results_table";
Table.create(table1);

for (i = 0; i < nRows; i++) {

	//Area = getResult("Area", i);
	Table.set("Cell number",i,cell_number[i]);
	Table.set("Cell cycle classification",i,cell_cycle[i]);
	Table.set("Major Diameter",i, Major[i]);
	Table.set("Minor Diameter",i, Minor[i]);
	Table.set("Minor/Major axes",i,Circularity[i]);
    Table.set("Volume",i, Volume[i]);
    
	}

//Depends on the type of data selected to be saved, if RAW, stop here and save file, if CLEAN do extra clean to remove the BAD FIT cells and if BOTH do that and keep both files.
if(Options=="RAW"){

	//Select directory to save final table with parameter of interest results
	selectWindow(table1);

	// Specify the path to the CSV file
	dir1 = getDirectory("Choose Directory where to save final table");
	saveAs("Results", dir1+fileName+"_RAW_results.csv");

	print("      ");
	print("End of code for this file, click run again to do another table");
	print("      ");
	print("       ---------------------         ");
}else if(Options=="CLEAN"){
	
//Select directory to save final table with parameter of interest results
	selectWindow(table1);


// Deletes a row, or rows, with labels containing
// a specified string from the results tabel.
//
// Author: Tiago Ferreira

label = "BAD FIT";
all = true;

deleteChosenRows(label, all);

function deleteChosenRows(string, recursive) {
 for (i=0; i<(Table.size); i++) {
     
     l = Table.getString("Cell cycle classification", i);
    
     if (indexOf(l, string)!=-1) {
         Table.deleteRows(i,i);   //this is what deletes the desired row
         
         if (recursive)
         
             deleteChosenRows(string, true); //this is a loop that repeats for all the cases.
         else
             return;
     }
 }
}

// Get new number of rows after deletion of bad data
nRows = Table.size;

//Define variable as arrays to allocate data from columns in the table
Number_2 = newArray(nRows);
cell_cycle_2 = newArray(nRows);
Major_2 = newArray(nRows);
Minor_2 = newArray(nRows);
Circularity_2 = newArray(nRows);
Volume_2 = newArray(nRows);

// Loop through the rows and store the data in different arrays
for (r = 0; r < nRows; r++) {
	
    // Get the row and column data of the table and put them in the specific variables
    Number_2[r] = Table.get("Cell number",r);
    cell_cycle_2[r] = Table.getString("Cell cycle classification", r);
    Major_2[r] = Table.get("Major Diameter",r);
    Minor_2[r] = Table.get("Minor Diameter",r);
    Circularity_2[r] = Table.get("Minor/Major axes", r);
	Volume_2[r] = Table.get("Volume", r);
}

//Close previous table
selectWindow(table1);
run("Close");


//Create final results table with the Major diameter, Minor diameter and the volume
table2="Results_table_2";
Table.create(table2);

for (j = 0; j < nRows; j++) {
	
	Table.set("Cell number",j,Number_2[j]);
	Table.set("Cell cycle classification",j,cell_cycle_2[j]);
	Table.set("Major Diameter",j,Major_2[j]);
  	Table.set("Minor Diameter",j,Minor_2[j]);
    Table.set("Minor/Major axes", j,Circularity_2[j]);
	Table.set("Volume",j,Volume_2[j]);
	    
	}
	
//Select directory to save final table with parameter of interest results
selectWindow(table2);

// Specify the path to the CSV file
dir1 = getDirectory("Choose Directory where to save final table");
saveAs("Results", dir1+fileName+"_Final_Clean_Results.csv");

print("      ");
print("End of code for this file, click run again to do another table");
print("      ");
print("       ---------------------         ");

}else if(Options=="BOTH"){


	//Select directory to save final table with parameter of interest results
	selectWindow(table1);

	// Specify the path to the CSV file
	dir1 = getDirectory("Choose Directory where to save final table");
	saveAs("Results", dir1+fileName+"_RAW_results.csv");

	//Select directory to save final table with parameter of interest results
	name3=fileName+"_RAW_results.csv";
	selectWindow(name3);


// Deletes a row, or rows, with labels containing
// a specified string from the results tabel.
//
// Author: Tiago Ferreira

label = "BAD FIT";
all = true;

deleteChosenRows(label, all);

function deleteChosenRows(string, recursive) {
 for (i=0; i<(Table.size); i++) {
     
     l = Table.getString("Cell cycle classification", i);
    
     if (indexOf(l, string)!=-1) {
         Table.deleteRows(i,i);   //this is what deletes the desired row
         
         if (recursive)
         
             deleteChosenRows(string, true); //this is a loop that repeats for all the cases.
         else
             return;
     }
 }
}

// Get new number of rows after deletion of bad data
nRows = Table.size;

//Define variable as arrays to allocate data from columns in the table
Number_2 = newArray(nRows);
cell_cycle_2 = newArray(nRows);
Major_2 = newArray(nRows);
Minor_2 = newArray(nRows);
Circularity_2 = newArray(nRows);
Volume_2 = newArray(nRows);

// Loop through the rows and store the data in different arrays
for (r = 0; r < nRows; r++) {
	
    // Get the row and column data of the table and put them in the specific variables
    Number_2[r] = Table.get("Cell number",r);
    cell_cycle_2[r] = Table.getString("Cell cycle classification", r);
    Major_2[r] = Table.get("Major Diameter",r);
    Minor_2[r] = Table.get("Minor Diameter",r);
    Circularity_2[r] = Table.get("Minor/Major axes", r);
	Volume_2[r] = Table.get("Volume", r);
}

//Close previous table
selectWindow(name3);
run("Close");


//Create final results table with the Major diameter, Minor diameter and the volume
table2="Results_table_2";
Table.create(table2);

for (j = 0; j < nRows; j++) {
	
	Table.set("Cell number",j,Number_2[j]);
	Table.set("Cell cycle classification",j,cell_cycle_2[j]);
	Table.set("Major Diameter",j,Major_2[j]);
  	Table.set("Minor Diameter",j,Minor_2[j]);
    Table.set("Minor/Major axes", j,Circularity_2[j]);
	Table.set("Volume",j,Volume_2[j]);
	    
	}
	
//Select directory to save final table with parameter of interest results
selectWindow(table2);

// Specify the path to the CSV file
//dir1 = getDirectory("Choose Directory where to save final table");
saveAs("Results", dir1+fileName+"_Final_Clean_Results.csv");

print("      ");
print("End of code for this file, click run again to do another table");
print("      ");
print("       ---------------------         ");

}
