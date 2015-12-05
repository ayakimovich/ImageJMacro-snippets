Stack.getDimensions(width, height, channels, slices, frames);
numberOfFrames = slices;
Stack.setDimensions(channels, frames, numberOfFrames);

for (f=1; f<=numberOfFrames; f++){
	Stack.setFrame(f);
	run("Enhance Local Contrast (CLAHE)", "blocksize=63 histogram=256 maximum=3 mask=*None*");
}
//run("Despeckle", "stack");
//run("Subtract Background...", "rolling=20 stack");