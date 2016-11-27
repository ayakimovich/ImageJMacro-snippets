// Generic Batch Processing Macro
// Processing here: 
// - FFT BP filter for Transmission light pictures
// - invert b/w
// - enhance contrast
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich

setBatchMode(true);
//get the path from user input
sliceNumber = 46;
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
	else if (endsWith(list[i], ".tif"))
		fileList = Array.concat(fileList, list[i]);
}

//main for-loop
print ("start");
for(i=0; i<=fileList.length-1; i++){
	print (fileList[i]);
	//open an image from the list
	open(fileList[i]);
		
	// the actuall processing here
	title = getTitle();
	makeRectangle(234, 1002, 220, 43);
	run("Copy");
	newImage("Untitled", "RGB black", 220, 43, 1);
	run("Paste");
	run("Insert...", "source=Untitled destination="+title+" x=840 y=950");
	close();
	makeRectangle(97, 65, 1725, 932);
	run("Crop");
	// end of processing
	
	// get the title and save the image
	title = getTitle();
	title = replace(title, ".tif", "_cropped.tif");
	print("Saving: "+title);
	saveAs("Tiff", processedDir+File.separator+title);
	//close the window
	close();
	}
print ("end");

setBatchMode(false);