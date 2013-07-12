// Generic Batch Processing Macro
// Processing here: Swap z stack to t dimensions in a stack
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
processedDir=ReadPath+"8bit";
File.makeDirectory(processedDir);

list = getFileList(ReadPath);
//clean up the file list
dirList = newArray();
tritcList = newArray();
gfpList = newArray();
tlList = newArray();

for(i=0; i<=list.length-1; i++){
	if (endsWith(list[i], "/"))
		dirList = Array.concat(dirList, list[i]);
	else if (endsWith(list[i], "TRITC.stk.tif"))
		tritcList = Array.concat(tritcList, list[i]);
	else if (endsWith(list[i], "GFP.stk.tif"))
		gfpList = Array.concat(gfpList, list[i]);
	else if (endsWith(list[i], "_FFT_BP.tif"))
		tlList = Array.concat(tlList, list[i]);
}

//main for-loop
print ("start tritc");
for(i=0; i<=tritcList.length-1; i++){
	print (tritcList[i]);
	//open an image from the list
	open(tritcList[i]);
		
	// the actuall processing here
	setMinAndMax(4000, 8000);
	call("ij.ImagePlus.setDefault16bitRange", 0);
	run("8-bit");
	// end of processing
	
	// get the title and save the image
	title = getTitle();
	print("Saving: "+processedDir+File.separator+title);
	saveAs("Tiff", processedDir+File.separator+title);
	//close the window
	close();
	}
print ("end tritc");

//
print ("start gfp");
for(i=0; i<=gfpList.length-1; i++){

	print (gfpList[i]);
	//open an image from the list
	open(gfpList[i]);
		
	// the actuall processing here
	setMinAndMax(76, 3075);
	call("ij.ImagePlus.setDefault16bitRange", 0);
	run("8-bit");	
	// end of processing

	title = getTitle();
	print("Saving: "+processedDir+File.separator+title);
	saveAs("Tiff", processedDir+File.separator+title);
	//close the window
	close();
	}
print ("end gfp");

//
print ("start tl");
for(i=0; i<=tlList.length-1; i++){

	print (tlList[i]);
	//open an image from the list
	open(tlList[i]);
		
	// the actuall processing here
	setMinAndMax(20000, 25000);
	call("ij.ImagePlus.setDefault16bitRange", 0);
	run("8-bit");
	
	// end of processing
	
	// get the title and save the image
	title = getTitle();
	print("Saving: "+processedDir+File.separator+title);
	saveAs("Tiff", processedDir+File.separator+title);
	//close the window
	close();
	}
print ("end tl");