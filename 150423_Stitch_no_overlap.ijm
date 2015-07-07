// Artur Yakimovich (c) copyright 2015. University of Zurich

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
stitchedDir=ReadPath+"Stitched";
File.makeDirectory(stitchedDir);

fileNameCore = "150415-Francesca-Hela-Fucci-timelapse";
fileExt = '.TIF';
numberOfChannels = 4;
percentOverlap = '0';
rowList = newArray('B','C', 'D');
colList = newArray('02','03','04','05','06','07','08','09','10');
tilesX =  4;
tilesY = 4;

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
for (iTP=1; iTP<=tpDirList.length; iTP++){
	for(i=0; i<=numberOfChannels-1; i++){
		for(j=0; j<=rowList.length-1; j++){
			for(k=0; k<=colList.length-1; k++){
				wellName = rowList[j]+colList[k];
				print (wellName);
				print (fileNameCore+"_"+wellName+"_s{i}_w"+d2s(i+1,0)+fileExt);
			
				// the actuall processing here
	        		run("Stitch Grid of Images", "grid_size_x="+tilesY+" grid_size_y="+tilesY+" overlap="+percentOverlap+" directory="+ReadPath+tpDirList[iTP]+" file_names="+fileNameCore+"_"+wellName+"_s{i}_w"+d2s(i+1,0)+fileExt+" rgb_order=rgb output_file_name=TileConfiguration.txt start_x=1 start_y=1 start_i=1 channels_for_registration=[Red, Green and Blue] fusion_method=[Max. Intensity] fusion_alpha=1.50 regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50");
	       		        //run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x=3 grid_size_y=3 tile_overlap="+percentOverlap+" first_file_index_i=1 directory="+ReadPath+tpDirList[iTP]+" file_names=="+fileNameCore+"_"+wellName+"_s{i}_w"+d2s(i+1,0)+fileExt+" output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap subpixel_accuracy computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
				// end of processing
		
				// get the title and save the image
				timePointName = tpDirList[iTP];
				timePointName = replace(timePointName, "TimePoint_", "");
				timePointName = replace(timePointName, "/", "");
				saveName = stitchedDir+File.separator+wellName+"_w"+d2s(i+1,0)+"_t"+timePointName+".tif";
				
				print("Saving: " + saveName);
				saveAs("Tiff", saveName);
				//close the window
				close();
			}
		}
	}
}

print ("end");