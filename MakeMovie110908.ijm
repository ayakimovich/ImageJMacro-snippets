//  2011 (c) Artur Yakimovich University of Zurich
//change

print ("start");
ReadPath = "R:\\Data\\110806_Zombies\\Overviews";
SavePath = "R:\\Data\\110806_Zombies\\Overviews\\Movies";

//imaging sites dimensions


//change if other letters are involved
//RowLetterArray = newArray("C", "D", "E", "F");
//WellName = newArray("A01", "B01", "B04", "B07", "B10");
WellName = newArray("B01");
print(WellName.length);
for(j=0; j<=WellName.length-1; j++){
for(i=1; i<=3; i++){
Channel =  "w"+i;

//print (RowLetterArray.length);
//	for(i=0; i<=StitchX_well*StitchY_well; i++){
//		print(".*"+WellName+"_s*.._ "+Channel+".tif sort");
			run("Image Sequence...", "open="+ReadPath+File.separator+" number=6913 starting=1 increment=1 scale=100 file=[] or=.*"+WellName[j]+Channel+".tif sort");	
			rename(Channel);
			run("Size...", "width=1392 height=1040 depth=9 constrain average interpolation=Bilinear");
}
	


	run("Merge Channels...", "red=w3 green=w2 blue=w1 gray=*None*");
	saveAs("Tiff", ""+SavePath+File.separator+WellName[j]+"_RGB.avi");
//	}

close();
print ("done"+WellName[j]+Channel);
}
