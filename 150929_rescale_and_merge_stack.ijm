//rescaling and merging a stack
// Copyright (C) 2015. Artur Yakimovich. University of Zurich

//user defined variables begin
setBatchMode(true);
//regex pattern for a file including w1 channel, this is needed to identify unique sites
filePattern = "^.*_[A-H][0-9]*_s[0-9]_w1.*.tif"

patternRed = "w4";
minRed = 4000; 
maxRed = 18000;

patternGreen = "w3";
minGreen = 3500; 
maxGreen = 28000;

patternBlue = "w5";
minBlue = 700; 
maxBlue = 2500;

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
	setMinAndMax(minRed, maxRed);
    run("8-bit");
    
	// green
	greenFileName = replace(fileList[i], "w1", patternGreen);
	open(ReadPath+greenFileName);
	setMinAndMax(minGreen, maxGreen);
    run("8-bit");
    
	// blue
	blueFileName = replace(fileList[i], "w1", patternBlue);
	open(ReadPath+blueFileName);
	setMinAndMax(minBlue, maxBlue);
    run("8-bit");

    run("Merge Channels...", "c1="+redFileName+" c2="+greenFileName+" c3="+blueFileName+"");
    newFileName = replace(fileList[i], "w1", "merge");
	print(newFileName);
    saveAs("Tiff", processedDir +File.separator+ newFileName);
	run("Close All");

}
print(processedDir+" processing finished succesfully");
setBatchMode(false);