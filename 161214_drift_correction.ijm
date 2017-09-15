// Artur Yakimovich (c) copyright 2016. University College London



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

baseDriftX = 0;
baseDriftY = 4;

increaseIteratorX = 8;
increaseIteratorY = 0;

inDir = getDirectory("Select the input folder...");
resultDir = inDir+File.separator + "drift_corrected";
File.makeDirectory(resultDir);
fileList = getDirAndFileList(inDir, ".*.tif", "file"); 


print ("start");
for(i=1; i<=fileList.length-1; i++){
	open(fileList[0]);
	baseChannelTitle = getTitle();
	selectWindow(baseChannelTitle);
	makeLine(935, 119, 935, 326);
	print("base: "+baseChannelTitle);
	
	open(fileList[i]);
	alignChannelTitle = getTitle();
	selectWindow(alignChannelTitle);

	xDrift = baseDriftX + increaseIteratorX*i;
	yDrift = baseDriftY + increaseIteratorY*i;

	makeLine(935+xDrift, 119+yDrift, 935+xDrift, 326+yDrift);
	
	print("aligning: "+alignChannelTitle);
	
	run("Align Image by line ROI", "source="+alignChannelTitle+" target="+baseChannelTitle);
	run("8-bit");
	close(alignChannelTitle);
	selectWindow(alignChannelTitle+" aligned to "+baseChannelTitle);
	path = resultDir+File.separator+alignChannelTitle;
	saveAs("Tiff", path);
	close(alignChannelTitle);
	close(baseChannelTitle);
}

print ("done");