/* 
 *  Opera Pannel montage
 *  Artur Yakimovich (c) copyright 2016. UCL
 */

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

patternRGB = "_rgb";

patternGray = "_w3";

patternRed = "_w2";

patternGreen = "_w1";

patternBlue = "_w0";

columnsNum = 5;

wellsOfInterest = newArray( "E04_s4", "D09_s3", "E10_s5");

inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);
outDir = inDir + File.separator + "pannel";
File.makeDirectory(outDir);

namePattern = getDirAndFileList(inDir, ".*_rgb.tif", "file");
saveName = "";
for (iWOI=0; iWOI < wellsOfInterest.length; iWOI++){
	rgbFile = replace(namePattern[0], "[A-Z][0-9]{2}_s[0-9]", wellsOfInterest[iWOI]);
	saveName = saveName+"_"+wellsOfInterest[iWOI];
	rFile = replace(rgbFile, "_rgb", patternRed);
	gFile = replace(rgbFile, "_rgb", patternGreen);
	bFile = replace(rgbFile, "_rgb", patternBlue);
	grayFile = replace(rgbFile, "_rgb", patternGray);
		
	open(inDir+File.separator+rgbFile);
	open(inDir+File.separator+rFile);	
	open(inDir+File.separator+gFile);	
	open(inDir+File.separator+bFile);	
	open(inDir+File.separator+grayFile);

}
	run("Images to Stack", "name=Stack title=[] use");
	run("Make Montage...", "columns="+columnsNum+" rows="+wellsOfInterest.length+" scale=1 first=1 last="+wellsOfInterest.length*columnsNum+" increment=1 border=2 font=12");
	
	
//	title = replace(openImageNames[iSeries], ".lif", "");
//	title = replace(title, " ", "");
	title = "pannel_"+saveName+".tif";
	print("Saving: "+title);
	saveAs("Tiff", outDir+File.separator+title);
	selectWindow(title);
	close(title);
	selectWindow("Stack");
	close("Stack");
setBatchMode(false);
print("converting complete");
