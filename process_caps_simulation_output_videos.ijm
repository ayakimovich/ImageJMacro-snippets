// Artur Yakimovich(C)2013: process caps simulation output videos
// model OX size: 100 cells, resolution 1200 dpi
// Version: 130814
print ("start");
ReadPath = getDirectory("Choose a Directory");
processedDir=ReadPath+File.separator+"ROI";
File.makeDirectory(processedDir);

list = getFileList(ReadPath);
//clean up the file list
dirList = newArray();
fileList = newArray();

for(i=0; i<=list.length-1; i++){
	if (endsWith(list[i], "/"))
		dirList = Array.concat(dirList, list[i]);
	else if (endsWith(list[i], ".tif"))
		fileList = Array.concat(fileList, list[i]);
}

run("Image Sequence...", "open="+ReadPath+File.separator+fileList[0]+" number="+fileList.length+" starting=1 increment=1 scale=100 file=[] or=[] sort");
//start processing
//100 cells:
//makeRectangle(1240, 1200, 6590, 5220);
//50 cells:
makeRectangle(1247, 968, 6896, 5441);
run("Crop");

title = getTitle();
print("Saving: "+title);
saveAs("Tiff", processedDir+File.separator+title);

//downsample
run("Size...", "width=1280 height=1013 depth="+fileList.length+" constrain average interpolation=Bilinear");
saveAs("Tiff", processedDir+File.separator+"small_"+title);

run("Close");
print ("finished");