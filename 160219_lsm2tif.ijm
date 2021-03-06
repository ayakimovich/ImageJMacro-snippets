// Generic Batch Processing Macro
// Processing here: 
// - FFT BP filter for Transmission light pictures
// - invert b/w
// - enhance contrast
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich

setBatchMode(true);
//get the path from user input
resolutionFilter = true;
minResolution = 4;
maxResolution = 8;
ReadPath = getDirectory("Choose a Directory");
SavePath = ReadPath+"separate_channels";
File.makeDirectory(SavePath);
//create a new directory for the processed images
//processedDir=ReadPath+"Processed";
//File.makeDirectory(processedDir);


// get the title and save the image
function splitAndSave(SavePath, title){
	//print("Saving: "+title);
	title = replace(title, ".lsm", "");
	title = replace(title, " ", "");
	print("Saving: "+title);
	SaveDir = SavePath+File.separator+title;
	print(SaveDir);
	File.makeDirectory(SaveDir);
	run("Image Sequence... ", "format=TIFF digits=0 use save=["+SaveDir+"]");
	//close the window
}

list = getFileList(ReadPath);
//clean up the file list
dirList = newArray();
fileList = newArray();

for(i=0; i<=list.length-1; i++){
	if (endsWith(list[i], "/"))
		dirList = Array.concat(dirList, list[i]);
	else if (endsWith(list[i], ".lsm"))
		fileList = Array.concat(fileList, list[i]);
}

//main for-loop
print ("start");
for(i=0; i<=fileList.length-1; i++){
	print (fileList[i]);
	//open an image from the list
	open(fileList[i]);
		
	if (resolutionFilter == true){
		
		infoArray = split(getImageInfo(),'\n');
		imageResolutionArray = split(infoArray[6]," ");
		print(imageResolutionArray[1]);
		imageResolution = parseFloat(imageResolutionArray[1]);

		if ((imageResolution >= minResolution) && (imageResolution <= maxResolution)){
				title = getTitle();
				splitAndSave(SavePath, title);
				close();
			} else {
					close();
				}
		} 
	else {
		  title = getTitle();
		  splitAndSave(SavePath, title);
		  close();
		}
	}
print ("end");

setBatchMode(false);