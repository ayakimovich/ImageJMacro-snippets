/* 
 *  Elyra batch scaling and color merging
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

function scaleChannel(min, max, pattern, file){
	selectWindow(pattern+"-"+file);
	if (bitDepth() == 8){
		run("16-bit");
	}
	setMinAndMax(min, max);
	run("8-bit");
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

function autoScale(offsetMin,offsetMax){
	run("Enhance Contrast", "saturated=0 normalize");
	getMinAndMax(min,max);
	setMinAndMax(min+offsetMin, max+offsetMax);
}

function manualScale(title,pattern,min, max){
	if(matches(title, ".*"+pattern+".tif")){
		setMinAndMax(min, max);
		}
}



inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);
files = getDirAndFileList(inDir, ".*_Out.czi", "file"); 
outTifDir = inDir + File.separator + "tiffs";
File.makeDirectory(outTifDir);
outPngDir = inDir + File.separator + "pngs";
File.makeDirectory(outPngDir);
//colors = 3;
//patternRed = "C3";
//minRed = 500; 
//maxRed = 2500;

//patternGreen = "C2";
//minGreen = 200; 
//maxGreen = 30000;

//patternBlue = "C1";
//minBlue = 1800; 
//maxBlue = 13000;

offsetMin = 200;

offsetMax = 200;




for (i=0; i < files.length; i++) {
//	open(inDir+File.separator+files[i]);
	run("Bio-Formats Importer", "open=["+inDir+File.separator+files[i]+"] color_mode=Default rois_import=[ROI manager] split_timepoints split_channels view=Hyperstack stack_order=XYCZT series_1 series_2 series_3");
	//run("Split Channels");	
	//scaleChannel(minBlue, maxBlue, patternBlue, files[i]);
	//scaleChannel(minGreen, maxGreen, patternGreen, files[i]);
	//scaleChannel(minRed, maxRed, patternRed, files[i]);
	//run("Merge Channels...", "c1=["+patternRed+"-"+files[i]+"] c2=["+patternGreen+"-"+files[i]+"] c3=["+patternBlue+"-"+files[i]+"]");
	windowsList = getAllOpenWindows("names")
	for (iWindow=0; iWindow < windowsList.length; iWindow++) {
		selectWindow(windowsList[iWindow]);
		title = getTitle();

		title = replace(title, "_Out.czi - D2 #", "_s");
		title = replace(title, " T=0 C=", "_w");
		print("Saving: "+title);
		saveAs("Tiff", outTifDir+File.separator+title);
		autoScale(offsetMin,offsetMax);
		run("8-bit");
		saveAs("PNG", outPngDir+File.separator+title);
		close(title+".png");		
	}
}  

setBatchMode(false);
print("converting complete");
