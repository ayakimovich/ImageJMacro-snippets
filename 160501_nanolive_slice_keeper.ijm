// Generic Batch Processing Macro
// Processing here: 
// - FFT BP filter for Transmission light pictures
// - invert b/w
// - enhance contrast
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich

setBatchMode(true);
//get the path from user input
sliceNumber = 45;
ReadPath = getDirectory("Choose a Directory");
processedDir = ReadPath+"ProcessedDir";
File.makeDirectory(processedDir); 
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
	else if (endsWith(list[i], ".tiff"))
		fileList = Array.concat(fileList, list[i]);
}

//main for-loop
print ("start");
for(i=0; i<=fileList.length-1; i++){
	print (fileList[i]);
	//open an image from the list
	open(fileList[i]);
		
	// the actuall processing here
	run("Slice Keeper", "first="+sliceNumber+" last="+sliceNumber+" increment=1");
	// end of processing
	
	// get the title and save the image
	title = getTitle();
	title = replace(title, ".tif kept stack", ".tif");
	print("Saving: "+title);
	saveAs("Tiff", processedDir+File.separator+title);
	//close the window
	close();
	}
print ("end");

setBatchMode(false);