//change
print ("start");
ReadPath = "I:\\Data\\simulationsoutput\\simulationResults\\23-Jul-2012-18-6-10.224";
SavePath = "I:\\Data\\simulationsoutput\\simulationResults\\23-Jul-2012-18-6-10.224\\ROI";


//NumOfTimePoints = 130;
//Here
Filelist = getFileList(ReadPath);
print (Filelist.length);
//for(i=1; i<=NumOfTimePoints-1; i++){
//			if (i<10){iNumber= "00"+i;}
//			if (i>=10 && i<100){iNumber= "0"+i;}
//			if(i>=100){iNumber= i;}
for(i=0; i<=Filelist.length-1; i++){
	print (Filelist[i]);
	if (matches(Filelist[i], "\\w*-\\w*-\\w*.tif")) {
		print (Filelist[i]+" - processing..");
		open(ReadPath+File.separator+Filelist[i]);
		makeRectangle(1232, 712, 7216, 5704);
		run("Crop");
		saveAs("Tiff", SavePath+File.separator+Filelist[i]+"_roi.tif");
		close();
	}
	print ("time point "+i+" done");
}		
//open(ReadPath+File.separator+"CA_PSE_100_116_2"+iNumber+".tif");
//makeRectangle(1232, 712, 7216, 5704);
//run("Crop");
//saveAs("Tiff", SavePath+File.separator+iNumber+".tif");
//close();
//print ("time point"+i+"done");
//}
