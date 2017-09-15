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
function createDummyImage(width,height,name){
	newImage(name, "16-bit black", width, height, 1);
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
function saveCloseImage(outDir, title, closeFlag){
	print("Saving: "+title);
	saveAs("Tiff", outDir+File.separator+title);
	if(closeFlag==true){
		selectWindow(title+".tif");
		close(title+".tif");
	}
}


inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);
files = getDirAndFileList(inDir, ".*001.flex", "file");
outDir = inDir + File.separator + "tif_plq2";
File.makeDirectory(outDir);


patternGreen = "w2";
minGreen = 50; 
maxGreen = 3500;

patternBlue = "w1";
minBlue = 350; 
maxBlue = 3000;



offsetMin = 100;
offsetMax = 500;

for (iFiles=0; iFiles < files.length; iFiles++){
	//open(inDir+File.separator+files[iFiles]);

	startFile = 1+iFiles*5;
	endFile = 5+iFiles*5;
	run("Bio-Formats Importer", "open=["+inDir+File.separator+files[iFiles]+"] autoscale color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT series_list="+startFile+"-"+endFile);

	//cycle through all open windows, rename and in the last step create dummy images
	openImageNames = getAllOpenWindows("names");
	for (iWindow=0; iWindow < openImageNames.length; iWindow++){
		selectWindow(openImageNames[iWindow]);
		title = getTitle();
		//selectWindow(title);
		newTitle = replace(title,files[iFiles]+" - ","");
		newTitle = replace(newTitle,"Well ","");
		//arrange site names according to the opera pattern
			newTitle = replace(newTitle,"; Field #1","_s2");
			newTitle = replace(newTitle,"; Field #2","_s5");
			newTitle = replace(newTitle,"; Field #3","_s6");
			newTitle = replace(newTitle,"; Field #4","_s4");
			newTitle = replace(newTitle,"; Field #5","_s8");
		newTitle = replace(newTitle," - C=","_w");
		if(matches(newTitle,".*[A-Z]-[1-9]{1}_.*")){
			newTitle = replace(newTitle,"-","0");
		}
		else{
			newTitle = replace(newTitle,"-","");
		}
		newTitle = replace(newTitle,"00","0");
		saveCloseImage(outDir, newTitle, true);
		//create dummy images for one imsge of the series
		if(matches(newTitle,".*_s2.*")){
			createDummyImage(668,495,replace(newTitle,"_s2","_s1"));
			saveCloseImage(outDir, replace(newTitle,"_s2","_s1"), true);
			createDummyImage(668,495,replace(newTitle,"_s2","_s3"));
			saveCloseImage(outDir, replace(newTitle,"_s2","_s3"), true);
			createDummyImage(668,495,replace(newTitle,"_s2","_s7"));
			saveCloseImage(outDir, replace(newTitle,"_s2","_s7"), true);
			createDummyImage(668,495,replace(newTitle,"_s2","_s9"));
			saveCloseImage(outDir, replace(newTitle,"_s2","_s9"), true);			
		}
	}
}

files = getDirAndFileList(outDir, ".*_w1.tif", "file"); 
for (iFiles=0; iFiles < files.length; iFiles++){
	titleBlue = files[iFiles];
	titleGreen = replace(files[iFiles],"w1","w2");
	
	open(inDir+File.separator+titleBlue);
	open(inDir+File.separator+titleGreen);

	run("Merge Channels...", c2="+titleGreen+" c3="+titleBlue+");
	run("RGB Color");
	selectWindow("RGB");
	title = replace(titleBlue, "w1", "w3");
	saveAs("Tiff", outDir+File.separator+title);
}
setBatchMode(false);
print("converting complete");
