getDimensions(width, height, channels, slices, frames);
for (i=1;i<=slices;i++){
	setSlice(i);
	sliceName = getInfo("slice.label");
	print(sliceName);
	//run("Next Slice [>]");
}