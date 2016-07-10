// Generic Batch Processing Macro
// Processing here: 
// - FFT BP filter for Transmission light pictures
// - invert b/w
// - enhance contrast
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich

setBatchMode(true);
//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
//processedDir=ReadPath+"Processed";
//File.makeDirectory(processedDir);

list = getFileList(ReadPath);
//clean up the file list
dirList = newArray();
fileList = newArray();

function claheStack(numberOfFrames){
		for (f=1; f<=numberOfFrames; f++){
			Stack.setFrame(f);
			run("Enhance Local Contrast (CLAHE)", "blocksize=63 histogram=256 maximum=3 mask=*None*");
		}
	}


for(i=0; i<=list.length-1; i++){
	if (endsWith(list[i], "/"))
		dirList = Array.concat(dirList, list[i]);
	else if (matches(list[i], ".*w1.*"))
		fileList = Array.concat(fileList, list[i]);
}

//main for-loop
print ("start");
for(i=0; i<=fileList.length-1; i++){
	print (fileList[i]);
	//open an image from the list
	open(fileList[i]);
		
	// the actuall processing here
		// the actuall processing here
	Stack.getDimensions(width, height, channels, slices, frames);
	numberOfFrames = slices;
	Stack.setDimensions(channels, frames, numberOfFrames);
	claheStack(numberOfFrames);
	run("Gaussian Blur...", "sigma=5 stack");
	run("Bandpass Filter...", "filter_large=100 filter_small=3 suppress=Horizontal tolerance=5 autoscale process");
	run("Invert", "stack");
	run("Subtract Background...", "rolling=18 stack");
	run("Enhance Contrast", "saturated=0.35");
	// end of processing
	
	// get the title and save the image
	title = getTitle();
	title = replace(title, "w1", "w4");
	print("Saving: "+title);
	saveAs("Tiff", ReadPath+File.separator+title);
	//close the window
	close();
	}
print ("end");

setBatchMode(false);