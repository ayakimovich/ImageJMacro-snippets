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
files = getDirAndFileList(inDir, ".*.tif", "file"); 
outDir = inDir + File.separator + "8-bit";
File.makeDirectory(outDir);

patternRed = "w2";
minRed = 100; 
maxRed = 2500;

patternGreen = "w1";
minGreen = 50; 
maxGreen = 3500;

patternBlue = "w0";
minBlue = 350; 
maxBlue = 3000;

patternGray = "w3";
minGray = 50; 
maxGray = 300;

offsetMin = 100;
offsetMax = 500;

for (iFiles=0; iFiles < files.length; iFiles++){
	open(inDir+File.separator+files[iFiles]);
	title = getTitle();
	selectWindow(title);
	//autoScale(offsetMin,offsetMax);
	manualScale(title,patternGray,minGray, maxGray);
	manualScale(title,patternBlue,minBlue, maxBlue);
	manualScale(title,patternRed,minRed, maxRed);
	manualScale(title,patternGreen,minGreen, maxGreen);
	
	run("8-bit");	
	//run("Slice Keeper", "first="+sliceNumber+" last="+sliceNumber+" increment=1");
	//title = replace(title, ".tif", "_8bit.tif");

	print("Saving: "+title);
	saveAs("Tiff", outDir+File.separator+title);
	selectWindow(title);
	close(title);
}

files = getDirAndFileList(outDir, ".*_w0.tif", "file"); 
for (iFiles=0; iFiles < files.length; iFiles++){
	titleBlue = files[iFiles];
	titleRed = replace(files[iFiles],"w0","w2");
	titleGreen = replace(files[iFiles],"w0","w1");
	titleGray = replace(files[iFiles],"w0","w3");
	
	open(inDir+File.separator+titleBlue);
	open(inDir+File.separator+titleGreen);
	open(inDir+File.separator+titleRed);
	open(inDir+File.separator+titleGray);
	run("Merge Channels...", "c1="+titleRed+" c2="+titleGreen+" c3="+titleBlue+" c4="+titleGray);
	selectWindow("RGB");
	title = replace(titleBlue, "w0", "rgb");
	saveAs("Tiff", outDir+File.separator+title);
}
setBatchMode(false);
print("converting complete");
