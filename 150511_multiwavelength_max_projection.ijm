// Max projections
// Artur Yakimovich (c) copyright 2015. University of Zurich

//get the path from user input
ReadPath = getDirectory("Choose a Directory");

new_wavelength = 'w5';
wavelength_list = newArray('w3', 'w4');
FileMask = "^.*_w1.TIF"

print ("start");
print ("reading files...");

TPPathList = getFileList(ReadPath);
selectedTPList = newArray();
for(i=0; i<=TPPathList.length-1; i++){
	if (matches(TPPathList[i], "TimePoint_[0-9]*/"))
		selectedTPList = Array.concat(selectedTPList, TPPathList[i]);
}



for (iTP = 0; iTP <= selectedTPList.length-1; iTP++){
	dirList = newArray();
	selectedFileList = newArray();
	list = getFileList(ReadPath+File.separator+selectedTPList[iTP]);
	
	print ("found " +list.length+" files...");
	
	for(i=0; i<=list.length-1; i++){
		if (endsWith(list[i], "/"))
			dirList = Array.concat(dirList, list[i]);
		else if (matches(list[i], FileMask))
			selectedFileList = Array.concat(selectedFileList, list[i]);
	}
	print("found "+ selectedFileList.length +" matching files");
	
	//main for loop
	
	for (i=0; i<=selectedFileList.length-1; i++){
	print ("starting the main loop...");
	print("processing " +selectedFileList[i]);	
		//open wavelengths to use for projection
		for (iWave=0; iWave <= wavelength_list.length-1; iWave++){
			newMask = wavelength_list[iWave];
			//print(newMask);
			newName = replace(selectedFileList[i], "w1" , newMask);
			//print(newName);
			open(ReadPath+File.separator+selectedTPList[iTP] +File.separator+ newName);
		}
		run("Images to Stack", "name=Stack title=[] use");
		run("Z Project...", "start=1 stop="+wavelength_list.length+" projection=[Max Intensity]");
	
		//save new file
		//exit("break point");
		saveAs("Tiff", ReadPath+File.separator+selectedTPList[iTP] +File.separator+ newFileName);
		run("Close All");
	}
}

