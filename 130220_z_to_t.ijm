// Generic Batch Processing Macro
// Processing here: Swap z stack to t dimensions in a stack
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
processedDir=ReadPath+"Processed";
File.makeDirectory(processedDir);

list = getFileList(ReadPath);
//clean up the file list
dirList = newArray();
fileList = newArray();

for(i=0; i<=list.length-1; i++){
	if (endsWith(list[i], "/"))
		dirList = Array.concat(dirList, list[i]);
	else
		fileList = Array.concat(fileList, list[i]);
}

//main for-loop
print ("start");
for(i=0; i<=fileList.length-1; i++){
	print (fileList[i]);
	//open an image from the list
	open(fileList[i]);
		
	// the actuall processing here
	Stack.getDimensions(width, height, channels, slices, frames);
	run("Properties...", "channels=1 slices="+frames+" frames="+slices+" unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000 frame=[0 sec] origin=0,0");
	// end of processing
	
	// get the title and save the image
	title = getTitle();
	print("Saving: "+processedDir+File.separator+title+".tif");
	saveAs("Tiff", processedDir+File.separator+title+".tif");
	//close the window
	close();
	}
print ("end");
