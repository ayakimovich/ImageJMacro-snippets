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
processedDir=ReadPath+"Phantoms_separate_channels";
File.makeDirectory(processedDir);
firstChannel = 2;
lastChannel = 4

list = getFileList(ReadPath);
//clean up the file list
dirList = newArray();
fileList = newArray();

for(iChannel=firstChannel; iChannel<=lastChannel; iChannel++){
	for(i=0; i<=list.length-1; i++){
		if (endsWith(list[i], "/"))
			dirList = Array.concat(dirList, list[i]);
		else if (endsWith(list[i], "w"+iChannel+".TIF_movie.tif"))
			fileList = Array.concat(fileList, list[i]);
	}
	
	//main for-loop
	print ("start");
	for(i=0; i<=fileList.length-1; i++){
		print (fileList[i]);
		//open an image from the list
		open(fileList[i]);
			
		// the actuall processing here
		run("Z Project...", "projection=[Sum Slices]");
		run("Bandpass Filter...", "filter_large=40 filter_small=3 suppress=None tolerance=5");
		run("Subtract Background...", "rolling=50");
		run("16-bit");
		// end of processing
		
		// get the title and save the image
		title = getTitle();
		title = replace(title, ".TIF_movie", "_phantom");
		print("Saving: "+title);
		saveAs("Tiff", processedDir+File.separator+title);
		//close the window
		close();
		close();
		call("java.lang.System.gc");
		}
}
print ("end");

setBatchMode(false);