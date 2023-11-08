# CocciVol
Combining FIJI and ilastik to provide a versatile and adaptable approach to automated Bacteria cell classification and cell volume determination from fluorescence images . This powerful combination of FIJI and ilastik (CocciVol) applied to Cocci bacterial cells provides an automated method with higher throughput of calculating the cell Volume.

#	0. How to navigate files in this GitHUB

The files in the main folder are three types of files:

- Information files = LICENSE and README.md which are only for your information about 	how to use, navigate and cite this GitHub.

- Main User Tutorial files = CocciVol_User_Manual_v1.pdf / I recommend download it and 	read it alongside visualising the video / CocciVol_Video_Tutorial_V1.txt, you can 	find the link to the video instide the text file.

- Folders = The folders are self-explanatory. To follow the video tutorial you should 	first download the "Tutorial_data_and_templates" to learn how to use the routine. You 	will also need to download the "FIJI macros" folder. Even more recommended is to 	Clone this whole GitHub folder into your computer / follow the link at the bottom of 	this README file. The additional files only contains another video with a bad audio 	but that might be usefulf for additional explanations / datasets might be added in 	the future as examples of this routine.

Within the folders, when you find a .zip file or a .txt file is because the original files were too big to upload into GitHub. Download and extract the files from the compressed .zip folders and click on the links inside the text .txt files.

#	1. Open-source programs that should be installed 

This should work for both Windows and iOS.
This process of installing the required programs should not require previous computing skills but if there are any troubleshooting contact us (see below the contact information).
-	FIJI/ImageJ (community-based software primarily to analyse fluorescence images)
	Download from [here](https://imagej.net/software/fiji/downloads) following website instructions (documentation section).
This is how FIJI looks after being installed and initialised (i.e. started). 

![image](https://github.com/Laia-Pasquina/CocciVol/assets/99417146/f3a996ba-1c60-4b53-a2a6-fa6fd3fd2d8d)

-	ilastik (user-friendly machine learning approach to image segmentation and analysis)
	Download from [here](https://www.ilastik.org/documentation/basics/installation) following website instructions (documentation section).

![image](https://github.com/Laia-Pasquina/CocciVol/assets/99417146/d05ed4ff-e4a4-46a3-b1e9-14b5258dc3ee)

 
This is how ilastik looks after being installed and initialised in Windows. 

![image](https://github.com/Laia-Pasquina/CocciVol/assets/99417146/0ec5f60b-4250-4166-b043-c1c7f755f0c0)

#	2. Required files and plugins to perform analysis

- Dataset of microscopy images
The first thing you need is a good set of images as your dataset. I recommend between 4-7 images of 160x140 um (the size can vary, see below, but this way the maximum amount of data is collected). This should be done for each sample, for example if you want to analyse a mutant with and without IPTG treatment, there should be two data sets of 7 images each to have 1 biological repeat. If a second biological repeat is required (it is recommended) then the amount of data should be doubled.
If the images are taken with a Nikon confocal microscope the format of the raw data files should be .nd2. However, because to read the raw data this approach uses the Bioformats from FIJI, any file format (for example .czi, .nd3, etc.) that is compatible with Bioformats should work.
- 2 Macros from FIJI
The 2 macros are the following:
(Macro1_Filtering_preparing_image.ijm and Macro2_Calculate_Volume_from_table.ijm) from FIJI that are required to perform this analysis can be found in this GitHub link  together with this documentation and a test sample (image_raw_1.nd2) to follow the video-tutorial. The macro files can be directly opened in FIJI and to run them simply click “run” as shown below:

![image](https://github.com/Laia-Pasquina/CocciVol/assets/99417146/88f43ffb-3a7b-4118-a160-e917b732cb1f)

There is no need to alter the macro code at all to perform this analysis, however if you feel confident and want to add some specific actions regarding your particular experiment, please download the code in your computer and alter it there, then upload it back on the GitHub with a different name (e.g. Macro1_XXX, where XXX are your initials).
- 2 ilastik projects
There are two situations that you can find yourself when approaching this routine:

*Situation 1:
You want to analyse a dataset of a bacterial strain (e.g. WT SH1000) that has been analysed before by someone else and the ilastik project contains the “trained” version of the program for this strain. Therefore, the analysis is much straightforward as it only requires you to perform batch analysis (see below on section 7 “Batch processing”). The two ilastik “trained” projects that you need should look like this:

 ![image](https://github.com/Laia-Pasquina/CocciVol/assets/99417146/2d3aad39-70c4-40e8-9030-ffe22119e30b)


where STRAIN_XXX is the name of your strain.


*Situation 2:
You want to analyse a dataset of a bacterial strain (e.g. WT SH1000 ∆tarO) that has never been analysed before with this routine. This is the most common situation you are going to find yourself, because it is more likely that you are the first researcher working in your specific strains. Therefore, you need to create two projects of ilastik from scratch and train the system (see below in sections 5 and 6 “Pixel and Object classification, training ilastik 1 and 2”).

- Install ilastik plugin in FIJI (correlating both programs)
Plugins are like “tools” that can be added to FIJI. The best way to do this is going to FIJI and click in: Help->Update… Sometimes the system requires updating because some modification has been added and no dialog will appear. Just close FIJI and open it again and repeat the process until the dialog with a list of things appear. Then click the button “Manage update sites”:

 ![image](https://github.com/Laia-Pasquina/CocciVol/assets/99417146/92d097ab-10e1-4fce-a505-38f2042d158b)

Then this other dialog will appear, it is a list of all possible plugins. Scroll down until you find “ilastik” it is in alphabetical order. Then click the box on the left of ilastik and click the button “Add update site”. Then the second dialog box will close and you can click “Apply changes” into the first dialog box and the update will proceed, installing the “ilastik”plugin. Then close FIJI and open again. You should be able to find a menu named “ilastik” at the very bottom of FIJI->Pluggins.

![image](https://github.com/Laia-Pasquina/CocciVol/assets/99417146/132a6f70-0c7b-4ad5-80ba-874648c8b6f7)

# For Filtering data, segmentation and volume calculation 

See the complete manual (which can be found in the main folder of this GitHub named "CocciVol manual.pdf") with the previous installing sections (1 and 2) and the following parts:

3.	Sort and prepare your files/folders
4.	Filtering process (preparing raw data)
5.	Pixel classification (training ilastik 1)
6.	Object classification (training ilastik_2)
7.	Batch processing
8.	Volume measurement from table

#USEFUL LINKS (CLONING)

https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository

