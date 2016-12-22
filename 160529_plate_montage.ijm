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
File.makeDirectory(SavePath);

//number corresponding to the w1, w2 etc.
nWavelength=3;
site=2;
scallingFactor=0.5;
plateName="2016-11-23-13-50-55";
//number or regex pattern


//imaging sites dimensions
StitchX_well = 1;
StitchY_well = 1;

//change if other letters are involved

RowLetterArray = newArray( "B", "C", "D", "E", "F", "G");
//RowLetterArray = newArray("A", "B", "C", "D", "E", "F", "G", "H");
//RowLetterArray = newArray("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P" );

//column of the first well imaged
startX_well = 2;
endX_well = 11;

//startY_well = 2;
endY_well = RowLetterArray.length-1;


NumOfTimePoints = 1;
//Here
for (wavelength=0; wavelength<=nWavelength; wavelength++){
	for(k=0; k<=NumOfTimePoints-1; k++){
	
	//print (RowLetterArray.length);
		for(i=0; i<=endY_well; i++){
			for(j=startX_well; j<=endX_well; j++){
				if(j<=9){jNumber= "0"+j;}
				else{jNumber= j;}
				print (jNumber);
				print (RowLetterArray[i]);
				print(plateName+"_"+RowLetterArray[i]+jNumber+"_s"+site+"_w"+wavelength+".tif");
				open(ReadPath+File.separator+plateName+"_"+RowLetterArray[i]+jNumber+"_s"+site+"_w"+wavelength+".tif");	
				if(StitchX_well > 1 || StitchY_well > 1){
					run("Make Montage...", "columns="+StitchX_well+" rows="+StitchY_well+" scale=1 first=1 last="+StitchX_well*StitchY_well+" increment=1 border=0 font=12");
					selectWindow("stitched");
					close();
				}
			}
		}
	
	run("Images to Stack", "name=Stack title=[] use");
	run("Size...", "width=200 height=224 constrain average interpolation=Bilinear");
	
	
	run("Make Montage...", "columns="+(endX_well-startX_well+1)+" rows="+endY_well+1+" scale="+scallingFactor+" first=1 last="+(endX_well-startX_well+1)*(endY_well+1)+"  increment=1 border=0 font=12");
	print ("montage done"+endX_well-startX_well+1+"and"+endY_well+1);
	//selectWindow("Stack");
	//close();
	
	
	saveAs("Tiff", SavePath+File.separator+"w"+wavelength+".tif");
	close();close();
	print ("done");
	}
}
setBatchMode(false);