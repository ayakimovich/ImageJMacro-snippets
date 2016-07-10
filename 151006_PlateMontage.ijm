//============================================================
//
// ImageJ Macro to create Plate montage from single IXM images
//    (c)2011-2016 Artur Yakimovich, University of Zurich 
//============================================================
//change

//Dialog.create("ImageXpress Micro Plate Montage");

//number corresponding to the w1, w2 etc.
firstWavelength=1;
lastWavelength=3;
//number or regex pattern
site=3;
//column of the first well imaged
StartX_well = 1;

//number of columns of wells imaged
StitchX_plate = 12;

//change if other letters are involved
//RowLetterArray = newArray("C", "D", "E", "F");
RowLetterArray = newArray("A", "B", "C", "D", "E", "F", "G", "H");

NumOfTimePoints = 1;



ReadPath = getDirectory("Choose a Directory");
SavePath = ReadPath+File.separator+"Montage";
print ("start "+ReadPath);
File.makeDirectory(SavePath);

setBatchMode(true);
//Here

for(iTP=0; iTP<=NumOfTimePoints-1; iTP++){
	for(wavelength = firstWavelength; wavelength = lastWavelength; wavelength++){
		for(i=0; i<=RowLetterArray.length-1; i++){
			for(j=0; j<=StitchX_plate-1; j++){
				if(j<=9-StartX_well){jNumber= "0"+j+StartX_well;}
				else{jNumber= j+StartX_well;}
				print (jNumber);
				print (RowLetterArray[i]);
				run("Image Sequence...", "open="+ReadPath+File.separator+"TimePoint_"+iTP+1+File.separator+" number=6913 starting=1 increment=1 scale=100 file=[] or=.*"+RowLetterArray[i]+jNumber+"_s"+site+"_w"+wavelength+".TIF sort");	
				}
			}


	run("Images to Stack", "name=Stack title=[] use");
	print ("montage done"+i+"and"+j);
	
	run("Make Montage...", "columns="+StitchX_plate+" rows="+RowLetterArray.length+" scale=1 first=1 last="+StitchX_plate*RowLetterArray.length+"  increment=1 border=0 font=12");
	selectWindow("Stack");
	close();
	
	if(NumOfTimePoints > 1){
		if(iTP<=9-1){TP= "0"+iTP+1;}
		else{TP= iTP+1;}
		saveAs("Tiff", SavePath+File.separator+TP+"_w"+wavelength+".tif");
		print ("time point"+TP+"done");
	
	}
	else{saveAs("Tiff", SavePath+File.separator+"w"+wavelength+"_s"+site+".tif");}
	close();
	print ("done");
	}
}
setBatchMode(false);