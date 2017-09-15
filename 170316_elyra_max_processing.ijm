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
	if(matches(title, ".*"+pattern+".*")){
		setMinAndMax(min, max);
		}
}

function semiManualScale(min, percentRange){
	setMinAndMax(min, floor((2^16-1)*percentRange));
}
function minMaxScale(offsetMin,offsetMax){
	getStatistics(area, mean, min, max, std, histogram);
	if(offsetMin <= 1 && offsetMax <= 1){
		inverseWindow = max-min;
		setMinAndMax(min+inverseWindow*offsetMin, max-inverseWindow*offsetMax);
	}
	else{
		strengthFactor = mean/65535;
		setMinAndMax(min+offsetMin*strengthFactor, max-offsetMax*strengthFactor);
	}
}

function titleProcessingBFStyle(title){
	title = replace(title, "_Orig.czi - [A-Z][0-9]* #", "_s");
	title = replace(title, " - T=0 C=", "_w");
	return title;
}
function titleProcessingIJStyle(title){
	if(matches(title, "C1-.*")){
		title = replace(title, "_Orig.czi", "_w1");
		title = replace(title, "C1-", "");
		run("Blue");
	}
	else if(matches(title, "C2-.*")){
		title = replace(title, "_Orig.czi", "_w2");
		title = replace(title, "C2-", "");
		run("Green");
	}
	else if(matches(title, "C3-.*")){
		title = replace(title, "_Orig.czi", "_w3");
		title = replace(title, "C3-", "");
		run("Red");
	}
	else if(matches(title, "C4-.*")){
		title = replace(title, "_Orig.czi", "_w4");
		title = replace(title, "C4-", "");
		run("Grays");
	}
	return title;
}
function iterateFolderWithSites(){
	for (iWells=0; iWells < wellFolders.length; iWells++) {
	siteFolders = getDirAndFileList(outPngDir+File.separator+wellFolders[iWells], "s.*", "folder");
	print("detected sites: "+siteFolders.length);
	for (iSites=0; iSites < siteFolders.length; iSites++) {
		fileNames = getDirAndFileList(outPngDir+File.separator+wellFolders[iWells]+File.separator+siteFolders[iSites], "w.*", "file");
		for (iFiles=0; iFiles < fileNames.length; iFiles++) {
			open(outPngDir+File.separator+wellFolders[iWells]+File.separator+siteFolders[iSites]+File.separator+fileNames[iFiles]);
		}
		windowsList = getAllOpenWindows("names");
		if(windowsList.length==4){
			run("Merge Channels...", "c1=["+windowsList[2]+"] c2=["+windowsList[1]+"] c3=["+windowsList[0]+"] c4=["+windowsList[3]+"]");	
			name = "RGB";
			saveAs("PNG", outPngDir+File.separator+wellFolders[iWells]+File.separator+siteFolders[iSites]+name);
			close(name);
		}
		else{print("wrong sorting...");}
		windowsListAfterSave = getAllOpenWindows("names");
		for(iWindow= 0; iWindow < windowsListAfterSave.length; iWindow++){
			close(windowsListAfterSave[iWindow]);
		}
	}
}
}
function iterateFolderWithoutSites(){
	for (iWells=0; iWells < wellFolders.length; iWells++) {

		fileNames = getDirAndFileList(inDir+File.separator+wellFolders[iWells], "w.*", "file");
		for (iFiles=0; iFiles < fileNames.length; iFiles++) {
			open(inDir+File.separator+wellFolders[iWells]+File.separator+fileNames[iFiles]);
		}
		windowsList = getAllOpenWindows("names");
		if(windowsList.length==4){
			run("Merge Channels...", "c1=["+windowsList[2]+"] c2=["+windowsList[1]+"] c3=["+windowsList[0]+"] c4=["+windowsList[3]+"]");	
			name = "RGB";
			saveAs("PNG", inDir+File.separator+wellFolders[iWells]+File.separator+name);
			print(name+" saved");
			close(name);
		}
		else{print("wrong sorting...");}
		windowsListAfterSave = getAllOpenWindows("names");
		for(iWindow= 0; iWindow < windowsListAfterSave.length; iWindow++){
			close(windowsListAfterSave[iWindow]);
		}
	}
}

print("start");
inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);
//run("Bio-Formats Macro Extensions");
files = getDirAndFileList(inDir, ".*_Orig.czi", "file"); 
outTifDir = inDir + File.separator + "tiffs-maxprocessed";
File.makeDirectory(outTifDir);
outPngDir = inDir + File.separator + "pngs-maxprocessed";
File.makeDirectory(outPngDir);
//colors = 3;

patternGray = "w4";
minGray = 300; 
maxGray = 7500;

patternRed = "w3";
minRed = 1000; 
maxRed = 5000;

patternGreen = "w2";
minGreen = 300; 
maxGreen = 1500;

patternBlue = "w1";
minBlue = 250; 
maxBlue = 650;

offsetMin = 65535;

offsetMax = 20000;

channelIgnorePattern = ""; //space separated


for (i=0; i < files.length; i++) {
//for (i=0; i < 1; i++) {
	run("Bio-Formats Importer", "open=["+inDir+File.separator+files[i]+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	//run("Bio-Formats Importer", "open=["+inDir+File.separator+files[i]+"] color_mode=Default rois_import=[ROI manager] split_timepoints split_channels view=Hyperstack stack_order=XYCZT series_1 series_2 series_3");
	//run("Bio-Formats Importer", "open=["+inDir+File.separator+files[i]+"] color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT");
	//Ext.openImagePlus(inDir+File.separator+files[i]);
	run("Split Channels");	

	windowsList = getAllOpenWindows("names");
	for (iWindow=0; iWindow < windowsList.length; iWindow++) {
		selectWindow(windowsList[iWindow]);
		run("Hyperstack to Stack");
		run("Z Project...", "projection=[Max Intensity]");
		title = replace(getTitle(),"MAX_","");
		title = titleProcessingIJStyle(title);
		print("Saving: "+title);
		saveAs("Tiff", outTifDir+File.separator+title);
		name = split(title,"_");
		print(name[2]);
		//minMaxScale(offsetMin,offsetMax);
		//autoScale(offsetMin,offsetMax);
		//semiManualScale(200, 0.9);
		manualScale(title,patternRed,minRed, maxRed);
		manualScale(title,patternGreen,minGreen, maxGreen);
		manualScale(title,patternBlue,minBlue, maxBlue);
		manualScale(title,patternGray,minGray, maxGray);
		run("8-bit");
		wellDir = outPngDir+File.separator+name[0];
		File.makeDirectory(wellDir);
		siteDir = wellDir+File.separator+name[1];
		File.makeDirectory(siteDir);
		saveAs("PNG", siteDir+File.separator+name[2]);
		close(name[2]+".png");
	}
}  


wellFolders = getDirAndFileList(outPngDir, "[A-Z].*", "folder");
print("detected wells: "+wellFolders.length);
//iterateFolderWithSites();

iterateFolderWithoutSites();
setBatchMode(false);
print("converting complete");
