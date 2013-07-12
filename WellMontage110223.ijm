//  2011 (c) Artur Yakimovich University of Zurich
//change
print ("start");
ReadPath = "D:\\AY-Data\\151206-AY-pVT1_Plate_191\\images";
SavePath = "D:\\AY-Data\\151206-AY-pVT1_Plate_191\\analysis";
//column of the first well imaged
StartX_well = 10;
//imaging sites dimensions
StitchX_well = 10;
StitchY_well = 9;
//number of columns of wells imaged
StitchX_plate = 1;

//change if other letters are involved
//RowLetterArray = newArray("C", "D", "E", "F");
RowLetterArray = newArray("D");

NumOfTimePoints = 183;
//Here

for(k=0; k<=NumOfTimePoints-1; k++){

//print (RowLetterArray.length);
	for(i=0; i<=RowLetterArray.length-1; i++){
		for(j=0; j<=StitchX_plate-1; j++){
			if(j<=9-StartX_well){jNumber= "0"+j+StartX_well;}
			else{jNumber= j+StartX_well;}
			print (jNumber);
			print (RowLetterArray[i]);
			run("Image Sequence...", "open="+ReadPath+File.separator+"TimePoint_"+k+1+File.separator+" number=6913 starting=1 increment=1 scale=100 file=[] or=.*"+RowLetterArray[i]+jNumber+"_s*.._w3_Thumb.TIF sort");	
			run("Make Montage...", "columns="+StitchX_well+" rows="+StitchY_well+" scale=1 first=1 last="+StitchX_well*StitchY_well+" increment=1 border=0 font=12");
			selectWindow("TimePoint_"+k+1+"");
			close();
		}
	}
//run("Images to Stack", "name=Stack title=[] use");
//print ("montage done"+i+"and"+j);

//run("Make Montage...", "columns="+StitchX_plate+" rows="+RowLetterArray.length+" scale=0.50 first=1 last="+StitchX_plate*RowLetterArray.length+"  increment=1 border=0 font=12");
//selectWindow("Stack");
//close();

if(k<=9-1){TP= "0"+k+1;}
else{TP= k+1;}
saveAs("Tiff", SavePath+File.separator+TP+".tif");
close();
print ("time point"+TP+"done");
}
