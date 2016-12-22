/* 
 *  Opera batch scaling and color merging
 *  Artur Yakimovich (c) copyright 2016. UCL
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

function scaleChannel(min, max, pattern, file, seriesName){
	selectWindow(pattern+"-"+seriesName);
	if (bitDepth() == 8){
		run("16-bit");
	}
	setMinAndMax(min, max);
	run("8-bit");
}




inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);
files = getDirAndFileList(inDir, ".*.flex", "file"); 
outDir = inDir + File.separator + "tiffs_renamed";
File.makeDirectory(outDir);

plateName = replace(inDir, ".*[(]", "");
plateName = replace(plateName, "/", "");
plateName = replace(plateName, "[)]", "");
plateName = replace(plateName, "_", "-");
print("plate name: "+plateName);
for (iFiles=0; iFiles < files.length; iFiles++){
	run("Bio-Formats Importer", "open=["+inDir+File.separator+files[iFiles]+"] autoscale color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT series_list="+iFiles);
	openImageNames = getAllOpenWindows("names");
	print("images open are: ");
	Array.print(openImageNames);
	
	for (iChannel=0; iChannel < openImageNames.length; iChannel++){
		selectWindow(openImageNames[iChannel]);
		title = getTitle;
		title = replace(title, " - ", "_");
		title = replace(title, "; Field #", "_s");
		title = replace(title, "C=", "w");
		title = replace(title, "Well ", "");
		title = replace(title, "-", "0");
		title = replace(title, "-", "");
		title = replace(title, "[0-9]*.flex", plateName);
		title = replace(title, "010", "10");
		title = replace(title, "011", "11");
		title = replace(title, "011", "12");
		print("Saving: "+title);
		saveAs("Tiff", outDir+File.separator+title+".tif");
		selectWindow(title+".tif");
		close(title+".tif");
	}
}

setBatchMode(false);
print("converting complete");
