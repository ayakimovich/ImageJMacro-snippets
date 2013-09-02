//draw whati separator bar
makeRectangle(1266, 0, 26, 1010);
setForegroundColor(255, 255, 255);
run("Fill", "stack");

//Paste gradient bar in the
//first frame
selectWindow("gradient-bar.tif");
run("Copy");
selectWindow("Combined Stacks");
makeRectangle(178, 972, 151, 16);
run("Paste");
//cycle
//makeRectangle(178, 972, 151, 16);
for(i=0; i<=59; i++){
run("Next Slice [>]");
run("Paste");
}

// time stamper
run("Time Stamper", "starting=1 interval=1 x=2256 y=134 font=80 decimal=0 anti-aliased or=hpi");

//scale bar
run("Set Scale...", "distance=25 known=22 pixel=1 unit=um");
run("Scale Bar...", "width=100 height=8 font=40 color=White background=None location=[Lower Right] bold label");

//Cell, text 60 pt
setForegroundColor(0, 150, 255);

//Infected cell, text 60 pt
setForegroundColor(0, 139, 40);


//VACV Wr, VACV IHD-J, text 60 pt
setForegroundColor(255, 255, 255);
makeRectangle(1, 0, 285, 120);

//min,max, text 24 pt
setForegroundColor(255, 255, 255);

