/* 
 *  Array data quantification
 *  
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



imageCommonEnding = "sk1fk1fl1.tiff";
startRows = 4;
endRows = 5;
startCols = 2;
endCols = 5;
startFields = 1;
endFields = 9;
startChan = 1;
endChan = 2;
imageWidth = 2160;
imageHeights = 2160;
savePath = getDirectory("Choose a Directory");

setBatchMode(true);
for (iRows=startRows;iRows<=endRows;iRows++){
	for (iCols=startCols;iCols<=endCols;iCols++){
			for (iFields=startFields;iFields<=endFields;iFields++){
				for (iChan=startChan;iChan<=endChan;iChan++){
					if(iRows<=9){
						row = "0"+d2s(iRows,0); 
					}
					else {
						row = d2s(iRows,0);
					}
					if(iCols<=9){
						col = "0"+d2s(iCols,0); 
					}
					else {
						col = d2s(iCols,0);
					}
					if(iFields<=9){
						field = "0"+d2s(iFields,0); 
					}
					else {
						field = d2s(iFields,0);
					}
					channel = d2s(iChan,0);
					name = "r"+row+"c"+col+"f"+field+"p01-ch"+channel+imageCommonEnding;
					newImage("Untitled", "16-bit black", imageWidth, imageHeights, 1);
					saveAs("Tiff", savePath+File.separator+name);
					close();
				}
			}
	}
}
setBatchMode(false);