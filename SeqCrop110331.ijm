//change
print ("start");
ReadPath = "D:\\AY-Data\\110330_simulations\\30-Mar-2011-14-19-58.105\\";
SavePath = "D:\\AY-Data\\110330_simulations\\30-Mar-2011-14-19-58.105\\ROI";


NumOfTimePoints = 130;
//Here

for(i=25; i<=NumOfTimePoints-1; i++){
			if (i<10){iNumber= "00"+i;}
			if (i>=10 && i<100){iNumber= "0"+i;}
			if(i>=100){iNumber= i;}
			print (iNumber);

open(ReadPath+File.separator+"CA_PSE_200_231_31-Mar-2011_"+iNumber+".tif");
makeRectangle(4123, 2862, 1430, 1430);
run("Crop");
saveAs("Tiff", SavePath+File.separator+iNumber+".tif");
close();
print ("time point"+i+"done");
}
