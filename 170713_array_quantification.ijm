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

title = getTitle();
saveFolder = "/Users/ayakimovich/Documents/blobbs";
selectWindow(title);
run("Montage to Stack...", "images_per_row=2 images_per_column=8 border=0");
selectWindow(title);
close();
selectWindow("Stack");
run("StackReg", "transformation=[Rigid Body]");
makeRectangle(58, 60, 144, 118);
//makeRectangle(52, 61, 140, 116);
run("Crop");
run("Canvas Size...", "width=146 height=120 position=Center zero");
run("Stack to Images");


openImageNames = getAllOpenWindows("names");
print("images open are: ");
Array.print(openImageNames);

for (iImage=0; iImage < openImageNames.length; iImage++){
	
	selectWindow(openImageNames[iImage]);
	run("Montage to Stack...", "images_per_row=6 images_per_column=5 border=0");
	close(openImageNames[iImage]);
	
	run("Image Sequence... ", "format=TIFF name=Array"+iImage+"_Blobb digits=2 save="+saveFolder);
	close();
}
