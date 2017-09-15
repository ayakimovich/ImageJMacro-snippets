/* 
 *  Circle ROI masking
 *  Artur Yakimovich (c) copyright 2017. UCL
 */

function regexReplacePy(inString, pattern){
	scritp = "import re"//+
//			 "p = re.compile("+pattern+""
	
	eval("python", script);
	return outString
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
outDir = inDir + File.separator + "movies_masked";
File.makeDirectory(outDir);


for (iFiles=0; iFiles < files.length; iFiles++){
	
	print (files[iFiles]);
	//open an image from the list
	open(files[iFiles]);
	
	makeOval(78, -10, 524, 524);
	
	run("Multiply...", "value=0.000 stack");
	run("Add Specified Noise...", "stack standard=10");
	run("Add...", "value=190 stack");
	//run("Add...", "value=80 slice");
	title = getTitle();
	print("Saving: "+outDir+File.separator+title);
	saveAs("Tiff", outDir+File.separator+title);
	
}
print ("end");