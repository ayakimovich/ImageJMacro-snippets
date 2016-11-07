//smb://file01.ucl.ac.uk/lmcb3/jm_ubvacv_s0816_f0718/EM_01_VACV-WT/300x400nm
/* 
 *  EM invert
 *  Artur Yakimovich (c) copyright 2016. UCL
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
files = getDirAndFileList(inDir, ".*.tif", "file"); 
outDir = inDir + File.separator + "inverted";
File.makeDirectory(outDir);


for (iFiles=0; iFiles < files.length; iFiles++){
	open(inDir+File.separator+files[iFiles]);
	run("Invert");
	title = getTitle();
	title = replace(title, ".tif", "_inverted.tif");
	//title = replace(title, " ", "_");
	print("Saving: "+title);
	saveAs("Tiff", outDir+File.separator+title);
	selectWindow(title);
	close(title);
	
}  

setBatchMode(false);
print("converting complete");
