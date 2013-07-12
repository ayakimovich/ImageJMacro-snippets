//change
print ("start");
ReadPath = "D:\\AY-Data\\110330_simulations\\30-Mar-2011-14-19-58.105\\";
SavePath = "D:\\AY-Data\\110330_simulations\\30-Mar-2011-14-19-58.105\\ROI";


NumOfTimePoints = 183;
//Here

for(i=1; i<=NumOfTimePoints-1; i++){
			if(i<=9){iNumber= "0"+i;}
			else{iNumber= i;}
			print (iNumber);

open(ReadPath+File.separator+iNumber+".tif");
makeRectangle(159, 2918, 2700, 2124);
run("Crop");
saveAs("Tiff", SavePath+File.separator+iNumber+".tif");
close();
print ("time point"+i+"done");
}
