//change
print ("start");
ReadPath = "R:\\Data\\111209-BlockingAS-1dpi_Plate_59\\Processed\\GFP\\";
SavePath = "R:\\Data\\111209-BlockingAS-1dpi_Plate_59\\Processed\\";

list = getFileList(ReadPath);

	for (i = 0; i < list.length-1; i++) {

		print (list[i]);
		open(ReadPath+File.separator+list[i]);

		run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None*");
		saveAs("Tiff", SavePath+File.separator+list[i]);

		run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None*");
		saveAs("Tiff", SavePath+File.separator+"CLAHE2"+File.separator+list[i]);

		close();
}

print ("CLAHE done");
