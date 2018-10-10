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
setBatchMode(false);
files = getDirAndFileList(inDir, ".*.nd2", "file");
outDir = inDir + File.separator + "classified";
File.makeDirectory(outDir);
class1Dir = outDir + File.separator + "intracellular";
File.makeDirectory(class1Dir);
class2Dir = outDir + File.separator + "extracellular";
File.makeDirectory(class2Dir);
for (iFiles=0; iFiles < files.length; iFiles++){
	run("Bio-Formats Importer", "open="+inDir+File.separator+files[iFiles]+" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack");
	//here user outlines the mask for splitting
	waitForUser("Add selections for the cell outline");
	
	title = getTitle();
	selectWindow(title);
	roiManager("Select", newArray(roiManager("count")));
	roiManager("Combine");
	run("Create Mask");
	selectWindow("Mask");
	run("Divide...", "value=255");
	imageCalculator("Multiply create stack", title,"Mask");
	selectWindow("Mask");
	close();
	selectWindow("Result of "+title);
	saveAs("Tiff", class1Dir+File.separator+title);
	close();
	selectWindow(title);
	roiManager("Select", newArray(roiManager("count")));
	roiManager("Combine");
	run("Make Inverse");
	run("Create Mask");
	selectWindow("Mask");
	run("Divide...", "value=255");
	imageCalculator("Multiply create stack", title,"Mask");
	selectWindow("Mask");
	close();
	selectWindow("Result of "+title);
	saveAs("Tiff", class2Dir+File.separator+title);
	selectWindow(title);
	close();
	close();
}
	