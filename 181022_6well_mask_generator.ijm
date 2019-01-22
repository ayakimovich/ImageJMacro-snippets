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

function addPlateOutline(title,maskDir){
	//add selctions
	//makePolygon(244,84,3512,100,3544,2312,172,2304);
	makePolygon(600,696,2752,664,2780,2124,584,2192);
	//here user outlines the mask for splitting
	waitForUser("Adjust selection for the plate outline");
	run("Create Mask");
	run("Invert LUT");
	roiManager("Deselect");
	selectWindow("Mask");
	saveAs("Png", maskDir+File.separator+title);
	close();
	selectWindow(title);
}


function add6WellsOutline(title,maskDir){
	//add selctions
	size = 623;
	startX=750;
	startY=410;
	stepX =730;
	stepY=730;
	for(i=0;i<3;i++){
		for(j=0;j<2;j++){
			makeOval(startX+i*stepX, startY+j*stepY, size, size);
			roiManager("Add");
			run("Select None");
		}
	}
	count = roiManager("count");
	print(count);
	selections = newArray();
	for(i=0;i<count;i++){
			Array.concat(selections,i);
		}
	Array.print(selections);
	roiManager("Show All with labels");
	//here user outlines the mask for splitting
	waitForUser("Adjust selection for the wells outline. Use ROI manager + Update to update wells position");

	roiManager("Select", selections);
	roiManager("Show All");
	roiManager("Combine");
	run("Create Mask");
	run("Invert LUT");
	selectWindow(title);
	
	roiManager("Select", newArray(roiManager("count")));
	roiManager("Delete");
	roiManager("Deselect");
	
	selectWindow("Mask");
	
	saveAs("Png", maskDir+File.separator+title);
	close();
	selectWindow(title);
}

inDir = getDirectory("Select the input folder..."); 
setBatchMode(false);
files = getDirAndFileList(inDir, ".*.jpg", "file");
outDir = inDir + File.separator + "masks";
File.makeDirectory(outDir);
mask1Dir = outDir + File.separator + "plateMask";
File.makeDirectory(mask1Dir);
mask2Dir = outDir + File.separator + "wellMask";
File.makeDirectory(mask2Dir);


for (iFiles=0; iFiles < files.length; iFiles++){
	roiManager("reset");
	//run("Bio-Formats Importer", "open="+inDir+File.separator+files[iFiles]+" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack");
	open(inDir+File.separator+files[iFiles]);
	title = getTitle();
	addPlateOutline(title,mask1Dir);
	roiManager("reset");
	add6WellsOutline(title,mask2Dir);
	roiManager("reset");
	close();
}
	