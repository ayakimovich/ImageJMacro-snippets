// Artur Yakimovich (c) copyright 2015. University of Zurich
setBatchMode(true);
//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
stitchedDir=ReadPath+"Stitched";
File.makeDirectory(stitchedDir);

fileNameCore = "151130-RH-20x-plaques";
fileExt = '.TIF';
numberOfChannels = 3;
percentOverlap = '0';
rowList = newArray('B','C', 'F', 'G');
//colList = newArray('02','03','04','05','06','07','08','09','10');
colList = newArray('02','06','07','08','09');
tilesX =  7;
tilesY = 7;
scale = 0.25;
first=1;
last=49;
increment=1;
border=0;

tpDirList = newArray();
listOfTimepoints = getFileList(ReadPath);

for(i=0; i<=listOfTimepoints.length-1; i++){
	if (matches(listOfTimepoints[i], "^TimePoint_[0-9]*/")){
		tpDirList = Array.concat(tpDirList, listOfTimepoints[i]);
		}
}

print ("TimePoints found: "+d2s(tpDirList.length,0));


//main for-loop

print ("start");
for (iTP=1; iTP<=tpDirList.length+1; iTP++){
	for(i=1; i<=numberOfChannels; i++){
		for(j=0; j<=rowList.length-1; j++){
			for(k=0; k<=colList.length-1; k++){
				wellName = rowList[j]+colList[k];
	
			print (wellName);
				
			
				// the actuall processing here
				run("Image Sequence...", "open=["+ReadPath+File.separator+tpDirList[iTP-1]+File.separator+fileNameCore+"_"+wellName+"_s1_w1.TIF] number=5881 starting=1 increment=1 scale=100 file=[] or=.*_"+wellName+"_s[0-9]*_w"+i+".TIF sort");
				//run("Image Sequence...", "open=[B:\\Rodinde Hendrickx\\151130-RH-20x-plaques_Plate_1932\\TimePoint_1\\151130-RH-20x-plaques_B02_s1_w1.TIF] number=5881 starting=1 increment=1 scale=100 file=[] or=.*_"+wellName+"_s[0-9]*_w"+i+".TIF sort");
				run("Make Montage...", "columns="+tilesX+" rows="+tilesY+" scale="+scale+" first="+first+" last="+last+" increment="+increment+" border="+border+" font=12");
	       		        //run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x=3 grid_size_y=3 tile_overlap="+percentOverlap+" first_file_index_i=1 directory="+ReadPath+tpDirList[iTP]+" file_names=="+fileNameCore+"_"+wellName+"_s{i}_w"+d2s(i+1,0)+fileExt+" output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap subpixel_accuracy computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
				// end of processing
		
				// get the title and save the image
				timePointName = tpDirList[iTP-1];
				timePointName = replace(timePointName, "TimePoint_", "");
				timePointName = replace(timePointName, "/", "");
				saveName = stitchedDir+File.separator+wellName+"_w"+d2s(i+1,0)+"_t"+timePointName+".tif";
				
				print("Saving: " + saveName);
				saveAs("Tiff", saveName);
				//close the window
				run("Close All");

			}
		}
	}
}

print ("end");
setBatchMode(false);