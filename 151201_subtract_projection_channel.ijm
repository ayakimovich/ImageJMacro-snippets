// Artur Yakimovich (c) copyright 2015. University of Zurich
print ("start");
// user defined variables begin
setBatchMode(true);
filePattern = "^.*[A-H][0-9]*_w1.*.TIF";
wavelengthToProject1 = "w2";
wavelengthToProject2 = "w3";
newWavelength = "w5;
projectionType = "Min Intensity"; //Max Intensity, Average Intensity, Sum Slices

// user defined variables end

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
list = getFileList(ReadPath);
dirList = newArray();
fileList = newArray();

for(i=0; i<=list.length-1; i++){
	if (endsWith(list[i], "/"))
		dirList = Array.concat(dirList, list[i]);
	else if (matches(list[i], filePattern))
		fileList = Array.concat(fileList, list[i]);
}

//main for-loop

print(fileList.length);
print ("start");

for(i=0; i<=fileList.length-1; i++){

	print (fileList[i]);
	fileName = replace(fileList[i], "w1", wavelengthToProject1);
	print(ReadPath+fileName);
	open(ReadPath+fileName);

	print (fileList[i]);
	fileName = replace(fileList[i], "w1", wavelengthToProject2);
	print(ReadPath+fileName);
	open(ReadPath+fileName);
	run("Images to Stack", "name=Stack title=[] use");
	//projection here
	run("Z Project...", "projection=["+projectionType+"]");

	newFileName = replace(fileList[i], "w1", newWavelength);
	print(newFileName);
    saveAs("Tiff", ReadPath+newFileName);
	run("Close All");
}