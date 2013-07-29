// Generic Batch Processing Macro
// Processing here: MetaXPress Images to stacks
// hint: use the native ImageJ Macro Recorder to change the processing command
// Artur Yakimovich (c) copyright 2013. University of Zurich
print ("start");
//get the path from user input
wavelength = "w3.TIF";
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
processedDir=ReadPath+File.separator+"Movies";
File.makeDirectory(processedDir);

list = getFileList(ReadPath);
Array.print(list);
//clean up the file list
dirList = newArray();
timePointsList = newArray();

for(i=0; i<=list.length-1; i++){
                //if (endsWith(list[i], "/"))
                  //              dirList = Array.concat(dirList, list[i]);
                if (startsWith(list[i], "TimePoint_"))
                                timePointsList = Array.concat(timePointsList, list[i]);
		else
				print("pattern not found");
				//exit();
}
Array.print(timePointsList);

fileList = getFileList(ReadPath+File.separator+timePointsList[0]);
imageList = newArray();
for(i=0; i<=fileList.length-1; i++){
                if (endsWith(fileList[i], wavelength))
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
print ("end");

