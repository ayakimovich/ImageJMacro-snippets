//change
print ("start");
ReadPathGreen = "D:\\AY-Data\\151206-AY-pVT1_Plate_191\\analysis\\green";
ReadPathRed = "D:\\AY-Data\\151206-AY-pVT1_Plate_191\\analysis\\red";
SavePath = "D:\\AY-Data\\151206-AY-pVT1_Plate_191\\analysis";
//column of the first well imaged

NumOfTimePoints = 183;
//Here

for(i=1; i<=NumOfTimePoints-1; i++){
			if(i<=9){iNumber= "0"+i;}
			else{iNumber= i;}
			print (iNumber);

open(ReadPathGreen+File.separator+iNumber+".tif");
open(ReadPathRed+File.separator+iNumber+".tif");
run("Merge Channels...", "red="+iNumber+"-1.tif green="+iNumber+".tif blue=*None* gray=*None*");

saveAs("Tiff", SavePath+File.separator+iNumber+".tif");
close();
print ("time point"+i+"done");
}
