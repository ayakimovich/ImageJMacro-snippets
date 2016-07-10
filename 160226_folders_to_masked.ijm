// Generic Batch Processing Macro
// Processing here: 
// - FFT BP filter for Transmission light pictures
// - invert b/w
// - enhance contrast
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich

//parameters definitions begin

ReadPath = getDirectory("Choose a Directory");
SavePath = getDirectory("Choose a Directory")+"merged_masked";
dirPattern = ".*"
cellFileName = "Ch2-T2.tif";
nucleiFileName = "ChS1-T1.tif";
File.makeDirectory(SavePath);

//parameters definitions end



//function definitions begin

function listFiles(path, filePattern){
	list = getFileList(path);
	fileList = newArray();
	
	for(i=0; i<=list.length-1; i++){
		if ((matches(list[i], filePattern)) && endsWith(list[i], "/") == false)
			fileList = Array.concat(fileList, list[i]);
	}
	return fileList;
}

function listDirs(path, dirPattern){
	list = getFileList(path);
	//clean up the file list
	dirList = newArray();
	
	for(i=0; i<=list.length-1; i++){
		if ((matches(list[i], dirPattern)) && endsWith(list[i], "/") == true)
			dirList = Array.concat(dirList, list[i]);
	}
	return dirList;
}

//function definitions end

dirList = listDirs(ReadPath, dirPattern);

//main for-loop
print ("start");

for(i=0; i<=dirList.length-1; i++){
	print (dirList[i]);
	//open an image from the list
	
	open(ReadPath+dirList[i]+cellFileName);
	run("Auto Threshold", "method=Huang white");
	//process
	run("Erode");
	run("Erode");
	run("Erode");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Minimum...", "radius=5");
	
	//mask
	run("Convert to Mask");
	run("Divide...", "value=255");

	open(ReadPath+dirList[i]+nucleiFileName);
	imageCalculator("Multiply", nucleiFileName,cellFileName);

	newFileName = replace(dirList[i], "/", "_")+"_"+"masked.tif";
	selectWindow(nucleiFileName);
	saveAs("Tiff", SavePath+File.separator+newFileName);
	close();
	selectWindow(cellFileName);
	close();
}
