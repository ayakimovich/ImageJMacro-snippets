// Generic Batch Processing Macro
// Processing here: Swap z stack to t dimensions in a stack
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
processedDir=ReadPath+"rgb";
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
	else if (endsWith(list[i], "FFT_BP.tif"))
		tlList = Array.concat(tlList, list[i]);
}

//main for-loop
print ("start color merge");
for(i=0; i<=tritcList.length-1; i++){
	print (tritcList[i]);
	//open an image from the list
	open(tritcList[i]);
	titleTRITC = getTitle();
	print("tritc title: "+titleTRITC);
	open(gfpList[i]);
	titleGFP = getTitle();
	print("tritc gfp: "+titleGFP);
	open(tlList[i]);
	titleTL = getTitle();
	print("tl title: "+titleTL);	
	// the actuall processing here
	run("RGB Gray Merge", "gray="+titleTL+" red="+titleTRITC+" green="+titleGFP+" blue=*None*");
	// end of processing
	
	// get the title and save the image
	title = getTitle();
	iname = i+1;
	print("Saving: "+processedDir+File.separator+iname+"rgb.tif");
	saveAs("Tiff", processedDir+File.separator+iname+"rgb.tif");
	//close the window
	close();
	}
print ("end color merge");
