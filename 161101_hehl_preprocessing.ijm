/* 
 *  TL high content processing
 *  Artur Yakimovich (c) copyright 2016
 */



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

inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);
fileList = getDirAndFileList(inDir, ".*_ch02.tif", "file"); 


print ("start");
	for(i=0; i<=fileList.length-1; i++){
	
	print(fileList[i]);
		//open an image from the list
		open(fileList[i]);
			
		// processing
		run("Bandpass Filter...", "filter_large=100 filter_small=3 suppress=None tolerance=5 autoscale saturate");
		run("Invert");
		run("Subtract Background...", "rolling=50");
		run("Median...", "radius=10");
		// end of processing
		
		// get the title and save the image
		title = getTitle();
		title = replace(title, "_ch02", "_ch03");
		print("Saving: "+title);
		saveAs("Tiff", inDir+File.separator+title);
		//close the window
		close(title);
		}

print ("end");

setBatchMode(false);