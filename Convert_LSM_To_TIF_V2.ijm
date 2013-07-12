/**
  * Convert lsm to tiff v2
  * Collaborators: 
  *     Cecile Gauthier, INSERM, CRBM, UMR5237, GTPases Rho; 
  *     Sophie Charrasse, CNRS, CRBM, UMR5237, GTPases Rho; 
  *     Rui Costa, Center for Neuroscience and Cell Biology, University of Coimbra, Portugal
  *
  * Work on a folder containing lsm files 
  *
  * For each file:
  *     - save the channels each as a tif file
  *     - save the overlay as an RGB tif file.
  *
  * (c) 2010, INSERM
  * written by Volker Baecker at Montpellier RIO Imaging (www.mri.cnrs.fr)
*/
 
inDir = getDirectory("Select the input folder!"); 
setBatchMode(true);
files = getFileList(inDir); 
outDir = inDir + "/" + "processed";
File.makeDirectory(outDir);
for (i=0; i < files.length; i++) {
     print("Update:converting image " + (i + 1) + " from " + files.length);
     if (endsWith(files[i], ".lsm")) { 
         open(inDir + "/" + files[i]); 
         title = getTitle();
         index = lastIndexOf(title, ".lsm");
         getDimensions(width, height, colors, slices, frames);
         if (colors>=2) {
             run("Make Composite");
             run("Stack to RGB");
              outName = substring(title, 0, index) + "-RGB.tif";
             save(outDir + "/" + outName);
            close();
            run("Split Channels");
             for (c=1; c < colors+1; c++) {
                 selectImage("C"+c+"-"+title);
                 run("8-bit");
                 outName = substring(title, 0, index) + "-C" + c + ".tif";
                 save(outDir + "/" + outName);
                 close();
             }
           close();
         } else {
             print ("skipped: " + inDir + "/" + title);
         }
     }  
}
setBatchMode(false);
print("finished converting");
