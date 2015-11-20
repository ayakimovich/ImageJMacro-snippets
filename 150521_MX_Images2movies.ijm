// Generic Batch Processing Macro
// Processing here: MetaXPress Images to stacks
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich
print ("start");
//get the path from user input
setBatchMode(true);
//wavelength = "B04_s9_w1.TIF";
//rowList = newArray('B','C','D','E','F','G');
rowList = newArray('B','C','D');

minCol = 2;
maxCol = 11;
minSite = 1;
maxSite = 9;
minW = 5;
maxW = 5;
wavelength = "B02_s1_w1.TIF";
//rowList = newArray('D','E');

ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
processedDir=ReadPath+File.separator+"Movies";
File.makeDirectory(processedDir);

list = getFileList(ReadPath);
Array.print(list);
//clean up the file list
dirList = newArray();
timePointsList = newArray();
iTP = 0;
for(i=0; i<=list.length-1; i++){
                //if (endsWith(list[i], "/"))
                  //              dirList = Array.concat(dirList, list[i]);
                if (startsWith(list[i], "TimePoint_")){
                	iTP = iTP + 1;
                   	timePointsList = Array.concat(timePointsList, "TimePoint_"+iTP);}
				else
				print("pattern not found");
				//exit();
}
//Array.sort(timePointsList);
Array.print(timePointsList);
//exit()
fileList = getFileList(ReadPath+File.separator+timePointsList[0]);
Array.print(fileList);

for (iSite = minSite; iSite <= maxSite; iSite++){
	for (iRow = 0; iRow <= rowList.length-1; iRow++){	
		for (iCol = minCol; iCol <= maxCol; iCol++){
			for (iW = minW; iW <= maxW; iW++){
	
			if (iCol < 10){
				pattern = rowList[iRow]+"0"+iCol+"_s"+iSite+"_w"+iW+".TIF";
				}
			else {
				pattern = rowList[iRow]+iCol+"_s"+iSite+"_w"+iW+".TIF";
				}
			
			print(pattern);
			//exit();
			imageList = newArray();
			for(i=0; i<=fileList.length-1; i++){
			                if (endsWith(fileList[i], pattern))
			                                imageList = Array.concat(imageList, fileList[i]);
			                else
			                               print ("pattern not found in "+fileList[i]);
			}
			//main for-loop
			
			Array.print(imageList);
			//exit();
			
			
			for(i=0; i<=imageList.length-1; i++){
			                print (imageList[i]);
			                
			                //open an image from the list
			                for(j=0; j<=timePointsList.length-1; j++){
			                	print("time point: "+timePointsList[j]);
			                	open(ReadPath+File.separator+timePointsList[j]+File.separator+imageList[i]);
					}                
			                run("Images to Stack", "name="+imageList[i]);
			
			                // get the title and save the image
			                //title = getTitle();
			                print("Saving: "+imageList[i]);
			                saveAs("Tiff", processedDir+File.separator+imageList[i]+"_movie.tif");
			                //close the window
			                close();
			                }
		
			}
		}
	}
}
print ("end");
setBatchMode(false);