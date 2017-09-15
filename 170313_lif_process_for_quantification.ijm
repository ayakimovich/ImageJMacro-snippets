/* 
 *  SP5 batch processing
 *  Artur Yakimovich (c) copyright 2017. UCL
 */

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
	getStatistics(area, mean, min, max, std, histogram);
	if (bitDepth() == 8){
		run("16-bit");
	}
	setMinAndMax(min, max);
	run("8-bit");
}

function position2wells(position, firstRow, lastRow, firstColumn, lastColumn){
	genericRowList = newArray("A","B","C","D","E","F","G","H");
	currectRowList = newArray();
	iCurrentRow=0;
	for(iRow=firstRow-1;iRow<=lastRow-1;iRow++){
		currectRowList = Array.concat(currectRowList,genericRowList[iRow]);
	}
	nRows = currectRowList.length+1;
	nCols = lastColumn - firstColumn+1;
	
	position = replace(position, ".*Pos", "");
	position = replace(position, "_w.*", "");
	
	number = parseInt(position);
	currentRowNumber = floor((number-1)/nCols);
	row = currectRowList[currentRowNumber];
	if ((currentRowNumber+1)%2!=0){
		column = number - currentRowNumber*nCols +1;
	}
	else{
		column = (number - currentRowNumber*nCols - nCols)*(-1) +2;
	}
	
	if(column<=9){
		column = "0"+d2s(column,0);
	}
	else{
		column = d2s(column,0);
	}
	
	well = row+column;
	print("position: "+position+" converted into "+well);
	return well;
}


inDir = getDirectory("Select the input folder..."); 
setBatchMode(true);
files = getDirAndFileList(inDir, ".*.lif", "file"); 
outDir = inDir + File.separator + "tiffs";
File.makeDirectory(outDir);

sliceNumber = 5;
colors = 2;
//patternRed = "C3";
//minRed = 16; //9
//maxRed = 255; //95

patternGreen = "C2";
minGreen = 50; //9
maxGreen = 800; //95

patternBlue = "C1";
minBlue = 0; 
maxBlue = 1200; //255



for (iFiles=0; iFiles < files.length; iFiles++){
//	open(inDir+File.separator+files[i]);
	//run("Bio-Formats Importer", "open=["+inDir+File.separator+files[iFiles]+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
	run("Bio-Formats Importer", "open=["+inDir+File.separator+files[iFiles]+"] autoscale color_mode=Default open_all_series rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT");
	openImageNames = getAllOpenWindows("names");
	print("images open are: ");
	Array.print(openImageNames);
	for (iSeries=0; iSeries < openImageNames.length; iSeries++){
		title = openImageNames[iSeries];
		selectWindow(title);
		title = replace(title, ".lif - ", "_");
		title = replace(title, " - C=", "_w");
		title = replace(title, "_S001", "");
		title = replace(title, " ", "");
		title = replace(title, "Pos[0-9]{3}", position2wells(title, 2, 7, 2, 10));
		
		if(nSlices>1){
			run("Z Project...", "projection=[Max Intensity]");
		}
		//run("Split Channels");	
		//scaleChannel(minBlue, maxBlue, patternBlue, files[iFiles], "MAX_"+openImageNames[iSeries]);
		//scaleChannel(minGreen, maxGreen, patternGreen, files[iFiles], "MAX_"+openImageNames[iSeries]);
		//scaleChannel(minRed, maxRed, patternRed, files[iFiles], openImageNames[iSeries]);
		//run("Merge Channels...", "c1=["+patternRed+"-"+openImageNames[iSeries]+"] c2=["+patternGreen+"-"+openImageNames[iSeries]+"] c3=["+patternBlue+"-"+openImageNames[iSeries]+"]");
		//run("Merge Channels...", "c2=["+patternGreen+"-"+"MAX_"+openImageNames[iSeries]+"] c3=["+patternBlue+"-"+"MAX_"+openImageNames[iSeries]+"]");
		//close("RGB");
		//selectWindow("MAX_RGB");
		//run("Slice Keeper", "first="+sliceNumber+" last="+sliceNumber+" increment=1");

		print("Saving: "+title);
		saveAs("Tiff", outDir+File.separator+title);
		selectWindow(title+".tif");
		close(title+".tif");
	}
}  

setBatchMode(false);
print("converting complete");
