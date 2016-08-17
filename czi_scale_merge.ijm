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
	setMinAndMax(min, max);
	run("8-bit");
}




inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);
files = getDirAndFileList(inDir, ".*.czi", "file"); 
outDir = inDir + File.separator + "tiffs";
File.makeDirectory(outDir);

colors = 3;
patternRed = "C3";
minRed = 200; 
maxRed = 2000;

patternGreen = "C2";
minGreen = 200; 
maxGreen = 8000;

patternBlue = "C1";
minBlue = 1000; 
maxBlue = 18000;






for (i=0; i < files.length; i++) {
//	open(inDir+File.separator+files[i]);
	run("Bio-Formats Importer", "open=["+inDir+File.separator+files[i]+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
	run("Split Channels");	
	scaleChannel(minBlue, maxBlue, patternBlue, files[i]);
	scaleChannel(minGreen, maxGreen, patternGreen, files[i]);
	scaleChannel(minRed, maxRed, patternRed, files[i]);
	run("Merge Channels...", "c1=["+patternRed+"-"+files[i]+"] c2=["+patternGreen+"-"+files[i]+"] c3=["+patternBlue+"-"+files[i]+"]");
	selectWindow("RGB");
	print("Saving: "+files[i]);
	saveAs("Tiff", outDir+File.separator+files[i]);
	close();
//	close();
}  

setBatchMode(false);
print("converting complete");
