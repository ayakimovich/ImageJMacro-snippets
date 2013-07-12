// Plaque assay analysis
//change
print ("start");
ReadPath = "D:\\AY-Data\\111217_plaqueassays\\Combined\\Display";
SavePath = "D:\\AY-Data\\111217_plaqueassays\\Combined\\Analysis";

list = getFileList(ReadPath);

	for (i = 0; i < list.length-1; i++) {

		print (list[i]);
		open(ReadPath+File.separator+list[i]);
		
		run("Specify...", "width=800 height=800 x=50 y=50 oval");
		run("Crop");
		run("Make Inverse");
		run("Fill", "slice");
		run("8-bit");
		saveAs("Tiff", SavePath+File.separator+list[i]);
		
		run("Close");
}

print ("done");