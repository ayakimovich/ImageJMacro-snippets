// Time Series ROI Crop
// Artur Yakimovich (c) copyright 2015. University of Zurich

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
processedDir=ReadPath+"Processed";
File.makeDirectory(processedDir);

commonName = "1600517-VACV-Volume-TL1_D02_s1_w1_";
cropping_halfsize = 200;
number_of_wavelengths = 3;


path_to_x_coordinates_file = ReadPath+"manual_tracking_coordinates"+File.separator+commonName+"x.txt";
path_to_y_coordinates_file = ReadPath+"manual_tracking_coordinates"+File.separator+commonName+"y.txt";

//reading the coordinates files
//File.openAsString(path) - Opens a text file and returns the contents as a string. Displays a file open dialog box if path is an empty string. Use lines=split(str,"\n") to convert the string to an array of lines. 
	x_coordinates_str = File.openAsString(path_to_x_coordinates_file);
	y_coordinates_str = File.openAsString(path_to_y_coordinates_file);
	x_coordinates = split(x_coordinates_str,"\n");
	y_coordinates = split(y_coordinates_str,"\n");
	
for (w = 1; w <= number_of_wavelengths; w++){
	list = getFileList(ReadPath);
	dirList = newArray();
	selectedFileList = newArray();
	selectedFileMask = commonName+"w"+w+".*";
//selecting image files
	for(i=0; i<=list.length-1; i++){
		if (endsWith(list[i], "/"))
			dirList = Array.concat(dirList, list[i]);
		else if (matches(list[i], selectedFileMask))
			selectedFileList = Array.concat(selectedFileList, list[i]);
	}	
// get number of trajectories

	number_of_trajectories = x_coordinates.length / selectedFileList.length;

//iterate through all the selscted images and coordinates

	for(i=0; i<=number_of_trajectories-1; i++){
		print("trajectory #:" + i);
		for(j=0; j<=selectedFileList.length-1; j++){
			fileName = selectedFileList[j];
			print("Processing file:" + fileName);
			open(ReadPath + File.separator + fileName);			

			x_adjusted = (x_coordinates[selectedFileList.length*i+j]) - cropping_halfsize;
			y_adjusted = (y_coordinates[selectedFileList.length*i+j]) - cropping_halfsize;
			
			// adjust upper left corner coordinates to prevent selection outside the image
			if (x_adjusted < 0) {
				x_adjusted = 0;
			}
			if (y_adjusted < 0) {
				y_adjusted = 0;
			}
			
			makeRectangle(x_adjusted, y_adjusted,cropping_halfsize*2,cropping_halfsize*2);
			run("Crop");

			//adjust size if size is too small
			if(getHeight < cropping_halfsize*2){
				run("Canvas Size...", "width="+getWidth+" height="+cropping_halfsize*2+" position=Center zero");
			}
			if(getWidth < cropping_halfsize*2){
				run("Canvas Size...", "width="+cropping_halfsize*2+" height="+getHeight+" position=Center zero");
			}

			//adjust numbering
			if (i <= 9)
			    trjName = "0" + i;
			else
			    trjName = i;
			newName = substring(fileName, 0 , lengthOf(fileName)-4);
			print("Saving: " + processedDir + File.separator + newName + "_trj" + trjName +".tif");
			saveAs("Tiff", processedDir + File.separator + newName + "_trj" + trjName +".tif");
			close();
		}
	}

}