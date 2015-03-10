// Artur Yakimovich (c) copyright 2014. University of Zurich

//get the path from user input
ReadPath = getDirectory("Choose a Directory");
//create a new directory for the processed images
stitchedDir=ReadPath+"Stitched";
File.makeDirectory(stitchedDir);

fileNameCore = "140211-AY-JW-Rocket-TL";
fileExt = '.TIF';
numberOfChannels = 3;
percentOverlap = '10';
rowList = newArray('B','C');
colList = newArray('02','03','04','05','06','07','08','09','10','11');
//main for-loop
print ("start");
for(i=0; i<=numberOfChannels-1; i++){
	for(j=0; j<=rowList.length-1; j++){
		for(k=0; k<=colList.length-1; k++){
			wellName = rowList[j]+colList[k];
			print (wellName);
			print (fileNameCore+"_"+wellName+"_s{i}_w"+d2s(i+1,0)+fileExt);
		
			// the actuall processing here
        		run("Stitch Grid of Images", "grid_size_x=4 grid_size_y=4 overlap="+percentOverlap+" directory="+ReadPath+" file_names="+fileNameCore+"_"+wellName+"_s{i}_w"+d2s(i+1,0)+fileExt+" rgb_order=rgb output_file_name=TileConfiguration.txt start_x=1 start_y=1 start_i=1 channels_for_registration=[Red, Green and Blue] fusion_method=[Max. Intensity] fusion_alpha=1.50 regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50");
       		        //run("Stitch Grid of Images", "grid_size_x=4 grid_size_y=4 overlap=10 directory=E:\\AYData\\140915_Particles_to_gfp_model\\140211-AY-JW-Rocket_Plate_391\\TimePoint_1 file_names=140211-AY-JW-Rocket_B02_s{i}_w2.TIF rgb_order=rgb output_file_name=TileConfiguration.txt start_x=1 start_y=1 start_i=1 channels_for_registration=[Red, Green and Blue] fusion_method=[Max. Intensity] fusion_alpha=1.50 regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50");
			// end of processing
	
			// get the title and save the image
			
			print("Saving: "+stitchedDir+File.separator+wellName+"_w"+d2s(i+1,0)+".tif");
			saveAs("Tiff", stitchedDir+File.separator+wellName+"_w"+d2s(i+1,0)+".tif");
			//close the window
			close();
		}
	}
}


print ("end");
