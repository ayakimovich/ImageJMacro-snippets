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

inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);

maskDir = inDir+ File.separator +"masks/wellMask/";
targetSize = 620;
clearMask = true;

cropDir = inDir + File.separator + "crops";
File.makeDirectory(cropDir);

//run("Analyze Particles...", "clear add");
files = getDirAndFileList(inDir, ".*.jpg", "file");

for (iFiles=0; iFiles < files.length; iFiles++){
	open(maskDir+File.separator+replace(files[iFiles],"jpg","png"));
	
	run("Create Selection");
	roiManager("Split");
	numberOfWells = roiManager("count");
	print("Dected wells "+numberOfWells);
	imageName = getTitle();
	
	
	for (iWell=0;iWell<numberOfWells;iWell++){
		open(inDir+File.separator+files[iFiles]);
		roiManager("Select", iWell);
		slectionName = call("ij.plugin.frame.RoiManager.getName", iWell);
		if(clearMask == true){
			run("Make Inverse");
			setBackgroundColor(0, 0, 0);
			run("Clear", "slice");
			run("Make Inverse");
		}
		
		run("Crop");
		run("Select None");
		title = imageName+"_y"+replace(slectionName,"-","_x");
		run("Size...", "width="+targetSize+" height="+targetSize+" average interpolation=Bicubic");
		path = cropDir+File.separator+replace(title,".png","")+".tif";
		saveAs("Tiff", path);
		print(path);
		close();
	}
	close();
	roiManager("reset");
}

print("crop complete");
setBatchMode(false);