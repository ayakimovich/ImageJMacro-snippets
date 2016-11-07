/*
 * vCLEM Ghost Processing
 * Copyright 2016 Artur Yakimovich, PhD
 */

// Procesing parameters
rollingBallRadius = 45;
medianRadius = 4;

// Inititlaization
imageTitle = getTitle();

// Processign
run("Duplicate...", "title=ghost duplicate");
selectWindow("ghost");
run("Invert", "stack");
run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None*");
run("Median...", "radius="+medianRadius+" stack");
run("Subtract Background...", "rolling="+rollingBallRadius+" stack");

//Produce a Composite
run("Merge Channels...", "c1="+imageTitle+" c2=ghost create");
run("Grays");
run("Arrange Channels...", "new=21");
//run("Channels Tool...");
Stack.setActiveChannels("11");
Stack.setDisplayMode("grayscale");
Stack.setChannel(2);
