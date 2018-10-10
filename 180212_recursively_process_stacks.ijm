function process(){
	print((count++) + ": " + dir + list[i]);
    open(dir+list[i]);
	title = getTitle();
	print(title);
	run("Split Channels");
	//selectWindow(title);
	//close();
	selectWindow("C2-"+title);
	close();
	selectWindow("C3-"+title);
	close();
	selectWindow("C4-"+title);
	close();
	selectWindow("C1-"+title);
	run("Z Project...", "projection=[Max Intensity]");
	run("Median...", "radius=4");
	saveAs("Tiff", dir+"max_"+title);
    close();
    close();
	return title;
}
setBatchMode(true);
// Recursively lists the files in a user-specified directory.
// Open a file on the list by double clicking on it.

  dir = getDirectory("Choose a Directory ");
  count = 1;
  listFiles(dir); 

  function listFiles(dir) {
     list = getFileList(dir);
     for (i=0; i<list.length; i++) {
        if (endsWith(list[i], "/"))
           listFiles(""+dir+list[i]);
        else if (endsWith(list[i], ".tif"))

           title = process();

     }
  }