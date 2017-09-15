// Simulate Fluorescence from transmission light images
// Artur Yakimovich (c) copyright 2017. UCL

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
processedDir=ReadPath+"Processed";
File.makeDirectory(processedDir);

list = getFileList(ReadPath);
//clean up the file list
dirList = newArray();
fileList = newArray();
sufName = getString("Filename ends with:", ".tif");

for(i=0; i<=list.length-1; i++){
	if (endsWith(list[i], "/"))
		dirList = Array.concat(dirList, list[i]);
	else if (endsWith(list[i], sufName)) 
		fileList = Array.concat(fileList, list[i]);
}

//main for-loop
setBatchMode(true);
print ("start");
for(i=0; i<=fileList.length-1; i++){

	print (fileList[i]);
	//open an image from the list
	open(fileList[i]);
		
	// the actuall processing here
	
	run("Subtract Background...", "rolling=10 stack");
	run("Maximum...", "radius=1 stack");
	run("Gaussian Blur...", "sigma=3 stack");

	// end of processing
	
	// get the title and save the image
	title = getTitle();
	print("Saving: "+processedDir+File.separator+title);
	saveAs("Tiff", processedDir+File.separator+title);
	//close the window
	close();
	}
print ("end");

setBatchMode(false);