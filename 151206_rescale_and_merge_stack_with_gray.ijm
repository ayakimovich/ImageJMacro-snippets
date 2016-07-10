//rescaling and merging a stack
// Copyright (C) 2015. Artur Yakimovich. University of Zurich

//user defined variables begin
setBatchMode(true);
//regex pattern for a file including w1 channel, this is needed to identify unique sites
filePattern = "^.*_[A-H][0-9]*_s[0-9]_w1.*.tif"
preprocess = true;
patternRed = "w4";
minRed = 150; 
maxRed = 1800;

patternGreen = "w3";
minGreen = 150; 
maxGreen = 1800;

patternBlue = "w2";
minBlue = 50; 
maxBlue = 300;


patternGray = "w1";
minGray = 1200; 
maxGray = 6000;


//user defined variables end


//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images

processedDir=ReadPath+"Merged";
File.makeDirectory(processedDir);

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
print(fileList.length);
print ("start");

for(i=0; i<=fileList.length-1; i++){

	print (fileList[i]);
	//open an images from the list according from the respective channel
    //red are 4000 and 18000; for green 3500 and 28000; for blue 700 and 2500
	// red
	redFileName = replace(fileList[i], "w1", patternRed);
	print(ReadPath+redFileName);
	open(ReadPath+redFileName);	
	if(preprocess == true){
		print("preprocessing...");
		run("Enhance Contrast", "saturated=0.35");
		run("Subtract Background...", "rolling=50 stack");
	}
	setMinAndMax(minRed, maxRed);
    run("8-bit");
    
	// green
	greenFileName = replace(fileList[i], "w1", patternGreen);
	open(ReadPath+greenFileName);
	if(preprocess == true){
		run("Enhance Contrast", "saturated=0.35");
		run("Subtract Background...", "rolling=50 stack");
	}
	setMinAndMax(minGreen, maxGreen);
    run("8-bit");
    
	// blue
	blueFileName = replace(fileList[i], "w1", patternBlue);
	open(ReadPath+blueFileName);
	if(preprocess == true){
		run("Enhance Contrast", "saturated=0.35");
		run("Subtract Background...", "rolling=50 stack");
	}
	setMinAndMax(minBlue, maxBlue);
    run("8-bit");

	grayFileName = replace(fileList[i], "w1", patternGray);
	open(ReadPath+grayFileName);
	if(preprocess == true){
		run("Enhance Contrast", "saturated=0.35");
	}	
	setMinAndMax(minGray, maxGray);
    run("8-bit");



    run("Merge Channels...", "c1="+redFileName+" c2="+greenFileName+" c3="+blueFileName+" c4="+grayFileName+"");
    run("RGB Color", "slices keep");
    newFileName = replace(fileList[i], "w1", "merge");
	print(newFileName);
    saveAs("Tiff", processedDir +File.separator+ newFileName);
	run("Close All");

}
print(processedDir+" processing finished succesfully");
setBatchMode(false);