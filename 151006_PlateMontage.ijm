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
File.makeDirectory(SavePath);
//number corresponding to the w1, w2 etc.
wavelength=3;
//number or regex pattern
site=3;
//column of the first well imaged
StartX_well = 1;
//imaging sites dimensions
StitchX_well = 1;
StitchY_well = 1;
//number of columns of wells imaged
StitchX_plate = 12;

//change if other letters are involved
//RowLetterArray = newArray("C", "D", "E", "F");
RowLetterArray = newArray("A", "B", "C", "D", "E", "F", "G", "H");

NumOfTimePoints = 1;
//Here

for(k=0; k<=NumOfTimePoints-1; k++){

//print (RowLetterArray.length);
	for(i=0; i<=RowLetterArray.length-1; i++){
		for(j=0; j<=StitchX_plate-1; j++){
			if(j<=9-StartX_well){jNumber= "0"+j+StartX_well;}
			else{jNumber= j+StartX_well;}
			print (jNumber);
			print (RowLetterArray[i]);
			run("Image Sequence...", "open="+ReadPath+File.separator+"TimePoint_"+k+1+File.separator+" number=6913 starting=1 increment=1 scale=100 file=[] or=.*"+RowLetterArray[i]+jNumber+"_s"+site+"_w"+wavelength+".TIF sort");	
			if(StitchX_well > 1 || StitchY_well > 1){
				run("Make Montage...", "columns="+StitchX_well+" rows="+StitchY_well+" scale=1 first=1 last="+StitchX_well*StitchY_well+" increment=1 border=0 font=12");
				selectWindow("TimePoint_"+k+1+"");
				close();
			}
		}
	}
run("Images to Stack", "name=Stack title=[] use");
print ("montage done"+i+"and"+j);

run("Make Montage...", "columns="+StitchX_plate+" rows="+RowLetterArray.length+" scale=1 first=1 last="+StitchX_plate*RowLetterArray.length+"  increment=1 border=0 font=12");
selectWindow("Stack");
close();

if(NumOfTimePoints > 1){
	if(k<=9-1){TP= "0"+k+1;}
	else{TP= k+1;}
	saveAs("Tiff", SavePath+File.separator+TP+"_w"+wavelength+".tif");
	print ("time point"+TP+"done");

}
else{saveAs("Tiff", SavePath+File.separator+"w"+wavelength+"_s"+site+".tif");}
close();
print ("done");
}
setBatchMode(false);