// Analzye wings Macro (C) copyright 2015 mumbi and artur

// Define processing parameteres here - begin
numberOfTimesToCLAHE = 2;
numberOfTimesToSmooth = 3;
numberOfTimesToErode = 4;
numberOfTimesToDialate = 2;
regions_for_values_over = 250;
minimum_number_of_points = 200;

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
filePattern = "^.*DSC.*_[0-9]*.JPG" //change if it doesn't find any files

// Define processing parameteres here - end


//Create a directory to save results
SavePath = ReadPath+File.separator+"Thresholded";
print ("start "+ReadPath);
File.makeDirectory(SavePath);

//Read all the matching files from the folder provided by user
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
//main for-loop to iterate through all the files

print(fileList.length);
print ("start");

for(i=0; i<=fileList.length-1; i++){
	print (fileList[i]);

	print("opening: "+ReadPath+File.separator+fileList[i]);
	open(ReadPath+File.separator+fileList[i]);
	//Processing and segmentaion of the images
	run("Size...", "width=800 height=530 constrain average interpolation=Bilinear");
	run("Enhance Local Contrast (CLAHE)", "blocksize=63 histogram=256 maximum=3 mask=*None* ");
	run("8-bit");

	//run("Select Bounding Box (guess background color)");
	for (j=0; j<=numberOfTimesToCLAHE; j++){
		run("Subtract Background...", "rolling=30 light");
	}
	
	run("Bandpass Filter...", "filter_large=10 filter_small=3 suppress=None tolerance=5 autoscale saturate");
	
	//Smooth several times
	for (j=0; j<=numberOfTimesToSmooth; j++){
		run("Smooth");
	}

	run("Invert");
	run("Auto Threshold", "method=MaxEntropy white");
	setOption("BlackBackground", false);


	// Erode several times
	for (j=0; j<=numberOfTimesToErode; j++){
		run("Erode");
	}

	// Dialate several times
	for (j=0; j<=numberOfTimesToDialate; j++){
		run("Dilate");
	}


	run("Invert");
	run("Find Connected Regions", "allow_diagonal display_one_image display_results regions_for_values_over="+regions_for_values_over+" minimum_number_of_points="+minimum_number_of_points+" stop_after=-1");
	newFileName = replace(fileList[i], ".JPG", "_detected_regions");
	print(newFileName);
	saveAs("Tiff", SavePath +File.separator+ newFileName);
	saveAs("Results", SavePath +File.separator+ newFileName+".xls");
	//selectWindow("All connected regions.tif");
	run("Close All");
}