// Generic Batch Processing Macro
// Processing here: 
// - FFT BP filter for Transmission light pictures
// - invert b/w
// - enhance contrast
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
//processedDir=ReadPath+"Processed";
//File.makeDirectory(processedDir);

list = getFileList(ReadPath);
//clean up the file list
dirList = newArray();
fileList = newArray();

for(i=0; i<=list.length-1; i++){
	if (endsWith(list[i], "/"))
		dirList = Array.concat(dirList, list[i]);
	else if (matches(list[i], ".*_w2.*"))
		fileList = Array.concat(fileList, list[i]);
}

//main for-loop

print ("start");
for(i=0; i<=fileList.length-1; i++){

	print (fileList[i]);
	//open an image from the list
	open(fileList[i]);
		
	// the actuall processing here
	run("Subtract Background...", "rolling=10");
	//run("Enhance Contrast...", "saturated=0.4 equalize");
	// end of processing
	
	// get the title and save the image
	title = getTitle();
	print("Saving: "+title);
	saveAs("Tiff", ReadPath+File.separator+title+"_w5.tif");
	//close the window
	close();
	}
print ("end");