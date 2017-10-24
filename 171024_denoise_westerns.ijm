// Denoise western blots
// Artur Yakimovich (c) copyright 2017. UCL

function getDirAndFileList(ReadPath, filePattern, listType){
	//listType = "dir" or "file", file default
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
	if (listType == "dir"){
		return dirList;	
	}
	else if (listType == "file"){
		return fileList;
	}
	else {
		return fileList;
	}
	}
//get the path from user input
ReadPath = getDirectory("Choose a Image Directory");
//create a new directory for the processed images
processedDir=ReadPath+"denoised";
File.makeDirectory(processedDir);


//clean up the file list
fileList = getDirAndFileList(ReadPath, ".*.TIF", "file");

//main for-loop
setBatchMode(true);
print ("start");
for(i=0; i<=fileList.length-1; i++){

	print (fileList[i]);
	//open an image from the list
	open(fileList[i]);
		
	// the actuall processing here
	
	run("Remove Outliers...", "radius=5 threshold=200 which=Bright");
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