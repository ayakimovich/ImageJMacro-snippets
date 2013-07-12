//  2011 (c) Artur Yakimovich University of Zurich
//change

print ("start");
ReadPath = "R:\\Data\\110806_Zombies\\Overviews\\3dpi";
SavePath = "R:\\Data\\110806_Zombies\\Overviews";

FileName = "03dpi";
//imaging sites dimensions
StitchX_well = 6;
StitchY_well = 6;


//change if other letters are involved
//RowLetterArray = newArray("C", "D", "E", "F");
WellName = newArray("A01", "B01", "B04", "B07", "B10");
print(WellName.length);
for(j=0; j<=WellName.length-1; j++){
for(i=1; i<=3; i++){
Channel =  "w"+i;

//print (RowLetterArray.length);
//	for(i=0; i<=StitchX_well*StitchY_well; i++){
//		print("+ReadPath+File.separator+"".*"+WellName+"_s*.._ "+Channel+".tif sort");
			run("Image Sequence...", "open="+ReadPath+File.separator+" number=6913 starting=1 increment=1 scale=100 file=[] or=.*"+WellName[j]+"_s.*_"+Channel+".tif sort");	
			run("Make Montage...", "columns="+StitchX_well+" rows="+StitchY_well+" scale=1 first=1 last="+StitchX_well*StitchY_well+" increment=1 border=0 font=12");
//	}

saveAs("Tiff", SavePath+File.separator+FileName+WellName[j]+Channel+".tif");
close();
close();
print ("done"+WellName[j]+Channel);
}
}
