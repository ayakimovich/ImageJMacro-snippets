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
	if(matches(title, ".*"+pattern+".tif")){
		setMinAndMax(min, max);
		}
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
			//run("Merge Channels...", "c1=["+windowsList[2]+"] c2=["+windowsList[1]+"] c3=["+windowsList[0]+"] c4=["+windowsList[3]+"]");
			run("Merge Channels...", "c1=[] c2=["+windowsList[1]+"] c3=["+windowsList[0]+"] c4=["+windowsList[3]+"]");	
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

inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);
//files = getDirAndFileList(inDir, ".*_Out.czi", "file"); 
//outTifDir = inDir + File.separator + "tiffs";
//File.makeDirectory(outTifDir);
//outPngDir = inDir + File.separator + "pngs";
//File.makeDirectory(outPngDir);
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

wellFolders = getDirAndFileList(inDir, ".*", "folder");
print("detected wells: "+wellFolders.length);
//iterateFolderWithSites();

iterateFolderWithoutSites();
setBatchMode(false);
print("converting complete");