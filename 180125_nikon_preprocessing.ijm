/* 
 *  Elyra batch scaling and color merging
 *  Artur Yakimovich (c) copyright 2016. UCL
 */


function getDirAndFileList(ReadPath, pattern, listType){
	 //listType = "dir" or "file", file default
	 list = getFileList(ReadPath);
	//clean up the file list
	dirList = newArray();
	fileList = newArray();
	
	for(i=0; i<=list.length-1; i++){
		if (endsWith(list[i], pattern+"/"))
			dirList = Array.concat(dirList, list[i]);
		else if (matches(list[i], pattern))
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


function getAllOpenWindows(returnType){
		names = newArray(nImages); 
		ids = newArray(nImages);
		print("number of open Imgages is: " + nImages); 
		for (i=0; i < ids.length; i++){ 
        	selectImage(i+1); 
        	ids[i] = getImageID(); 
        	names[i] = getTitle(); 
        	print(ids[i] + " = " + names[i]);
		}
		if(returnType=="ids"){
           return ids;
        }
        else if(returnType=="names"){
           return names;
        }
}



print("start");
inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);
//run("Bio-Formats Macro Extensions");
files = getDirAndFileList(inDir, ".*.nd2", "file"); 


for (iFile=0; iFile < files.length; iFile++) {
	run("Bio-Formats", "open="+inDir+files[iFile]+" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	saveAs("Tiff",  inDir+replace(files[iFile], ".nd2", ".tif"));
	close();
}
setBatchMode(false);
print("converting complete");