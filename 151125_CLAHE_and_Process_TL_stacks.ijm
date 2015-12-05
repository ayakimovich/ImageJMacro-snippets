// Generic Batch Processing Macro
// Processing here: Swap z stack to t dimensions in a stack
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
TLwavelength = "w1";
newWavelength = "w5";

filePattern = ".*_"+TLwavelength+".*.tif";
setBatchMode(true);
list = getFileList(ReadPath);
//clean up the file list
dirList = newArray();
fileList = newArray();


for(i=0; i<=list.length-1; i++){
	if (endsWith(list[i], "/"))
		dirList = Array.concat(dirList, list[i]);
	else if (matches(list[i], filePattern))
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
	numberOfFrames = slices;
	Stack.setDimensions(channels, frames, numberOfFrames);

	for (f=1; f<=numberOfFrames; f++){
		Stack.setFrame(f);
		run("Enhance Local Contrast (CLAHE)", "blocksize=63 histogram=256 maximum=3 mask=*None*");
	}
	run("Despeckle", "stack");
	run("Subtract Background...", "rolling=20 stack");
	// end of processing
	
	// get the title and save the image
	newFileName = replace(fileList[i], TLwavelength, newWavelength);

	print("Saving: "+newFileName);
	saveAs("Tiff", ReadPath+File.separator+newFileName);
	//close the window
	close();
	}
print ("end");
setBatchMode(false);
