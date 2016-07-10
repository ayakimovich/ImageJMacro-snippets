//============================================================
//
// ImageJ Macro to create Plate montage from single IXM images
//    (c)2011-2012 Artur Yakimovich, University of Zurich 
//============================================================
//change
setBatchMode(true);

ReadPath = getDirectory("Choose a Directory");
SavePath = ReadPath+File.separator+"Montage";
print ("start "+ReadPath);
File.makeDirectory(SavePath)
;
//number corresponding to the w1, w2 etc.
wavelength=1;
//number or regex pattern

//column of the first well imaged
StartX_well = 1;
//imaging sites dimensions
StitchX_well = 1;
StitchY_well = 1;
//number of columns of wells imaged
StitchX_plate = 24;

//change if other letters are involved
//RowLetterArray = newArray("C", "D", "E", "F");
//RowLetterArray = newArray("A", "B", "C", "D", "E", "F", "G", "H");
RowLetterArray = newArray("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P" );
NumOfTimePoints = 1;
//Here
for (wavelength=1; wavelength<=2; wavelength++){
	for(k=0; k<=NumOfTimePoints-1; k++){
	
	//print (RowLetterArray.length);
		for(i=0; i<=RowLetterArray.length-1; i++){
			for(j=0; j<=StitchX_plate-1; j++){
				if(j<=9-StartX_well){jNumber= "0"+j+StartX_well;}
				else{jNumber= j+StartX_well;}
				print (jNumber);
				print (RowLetterArray[i]);
				print(RowLetterArray[i]+jNumber+"_w"+wavelength+".TIF");
				open(ReadPath+File.separator+RowLetterArray[i]+jNumber+"_w"+wavelength+".TIF");	
				if(StitchX_well > 1 || StitchY_well > 1){
					run("Make Montage...", "columns="+StitchX_well+" rows="+StitchY_well+" scale=1 first=1 last="+StitchX_well*StitchY_well+" increment=1 border=0 font=12");
					selectWindow("stitched");
					close();
				}
			}
		}
	
	run("Images to Stack", "name=Stack title=[] use");
	run("Size...", "width=200 height=224 constrain average interpolation=Bilinear");
	
	
	run("Make Montage...", "columns="+StitchX_plate+" rows="+RowLetterArray.length+" scale=1 first=1 last="+StitchX_plate*RowLetterArray.length+"  increment=1 border=0 font=12");
	print ("montage done"+StitchX_plate+"and"+RowLetterArray.length);
	//selectWindow("Stack");
	//close();
	
	
	saveAs("Tiff", SavePath+File.separator+"w"+wavelength+".tif");
	close();close();
	print ("done");
	}
}
setBatchMode(false);