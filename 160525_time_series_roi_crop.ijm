// Time Series ROI Crop
// Artur Yakimovich (c) copyright 2015. University of Zurich


// functions definitions
function readCoordinates(path_to_coordinates_file){
	//reading the coordinates files
	//File.openAsString(path) - Opens a text file and returns the contents as a string. 
	//Displays a file open dialog box if path is an empty string. Use lines=split(str,"\n") to convert the string to an array of lines. 

	coordinates_str = File.openAsString(path_to_coordinates_file);
	//File.close(path_to_coordinates_file);

	coordinates = split(coordinates_str,"\n");
	return coordinates;
	}


function getDirAndFileList(ReadPath, filePattern, listType){
 	//listType = "dir" or "file", file default
 	list = getFileList(ReadPath);
	//clean up the file list
	dirList = newArray();
	fileList = newArray();
		
	for(i=0; i<=list.length-1; i++){
		if (endsWith(list[i], "/") && matches(list[i], filePattern)){
			dirList = Array.concat(dirList, list[i]);
		}
		else if (matches(list[i], filePattern)){
			fileList = Array.concat(fileList, list[i]);
		}
	}
	if (listType == "dir"){
		return dirList;	
	}
	else if (listType == "file"){
		return fileList;
	}
	else {
		return fileList;
	}
}



//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
processedDir=ReadPath+"cropped_stacks";
File.makeDirectory(processedDir);

cropping_halfsize = 200;
number_of_timepoints = 106;
number_of_wavelengths = 3;


timePointsList = getDirAndFileList(ReadPath, "TimePoint_[0-9]*/", "dir");
Array.sort(timePointsList);
print("number of timepoints is:");
Array.print(timePointsList);
path_to_coordinates = ReadPath+"manual_tracking_coordinates";
trajectoriesList = getDirAndFileList(path_to_coordinates, ".*_x.txt", "file");
setBatchMode(true);


print("starting the main loop");	
for (w = 1; w <= number_of_wavelengths; w++){
	for(trj_file=0;trj_file<=trajectoriesList.length-1;trj_file++){
		// get number of trajectories
		print("reading coordinates");
		x_coordinates = readCoordinates(path_to_coordinates + File.separator + replace(trajectoriesList[trj_file],"_x","_x"));
		y_coordinates = readCoordinates(path_to_coordinates + File.separator + replace(trajectoriesList[trj_file],"_x","_y"));
		number_of_trajectories = x_coordinates.length / number_of_timepoints;
		print("number of trajectories: "+d2s(number_of_trajectories,0));
		//iterate through all the selected image folders and coordinates
		imageFileName = replace(trajectoriesList[trj_file],"1_x.txt",d2s(w,0)+".TIF");
		for(i=0; i<=number_of_trajectories-1; i++){
			print("trajectory #:" + d2s(i,0));
			for(iTP=0; iTP<=number_of_timepoints-1; iTP++){
				print("Processing file:" + imageFileName);
				//open(ReadPath + timePointsList[iTP] + File.separator + imageFileName); below a hack to avoid natural sorting - a bit faster
				open(ReadPath + "TimePoint_" + d2s(iTP+1,0) + File.separator + imageFileName);
				rename(d2s(iTP,0)+"_"+imageFileName);			
	
				x_adjusted = (x_coordinates[(i)*number_of_timepoints+(iTP)]) - cropping_halfsize;
				y_adjusted = (y_coordinates[(i)*number_of_timepoints+(iTP)]) - cropping_halfsize;
				
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
			}

			
			//adjust numbering
			if (i <= 9)
			    trjName = "0" + i;
			else
			    trjName = i;
			
			
			newName = substring(imageFileName, 0 , lengthOf(imageFileName)-4);
			//run("Images to Stack", "name="+newName+" title=[] use");
			run("Concatenate...", "all_open title=[Concatenated Stacks]");
			print("Saving: " + processedDir + File.separator + newName + "_trj" + trjName +".tif");
			saveAs("Tiff", processedDir + File.separator + newName + "_trj" + trjName +".tif");
			close("*");
		}
	
	}
}
setBatchMode(false);