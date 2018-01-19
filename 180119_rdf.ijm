//============================================================
//
// ImageJ1 Macro to compute Radial Distribution Function of an image, given a centroid
//    (c)2018 Artur Yakimovich, UCL
//============================================================
function getMin(x1,x2){
	if (x1<x2){
		min = x1;
		}
	else if(x2<x1){
		min =x2;
		}
	return min;
}

function selectRing(x,y,diam1,diam2){
	makeOval(x-diam1/2, y-diam1/2, diam1, diam1);
	roiManager("Add");
	run("Select None");
	makeOval(x-diam2/2, y-diam2/2, diam2, diam2);
	roiManager("Add");
	run("Select None");
	roiManager("Select", newArray(0,1));
	roiManager("XOR");
	roiManager("Delete");
}
function getCentroid(){
	run("Duplicate...", " ");
	setAutoThreshold("Default dark");
	run("Create Selection");
	List.setMeasurements;
	x = List.getValue("XM");
	y = List.getValue("YM");
	run("Close");
	coordinates = newArray(x, y);
	return coordinates;
}
//xCentroid = 51;
//yCentroid = 49;
coordinates = getCentroid();
xCentroid = coordinates[0];
yCentroid = coordinates[1];

radialStep = 5*2; // in pixels, *2 adjusts for diameter
getDimensions(width, height, channels, slices, frames);
arraySize = floor(getMin(width,height)/radialStep);

//reallocate arrays and initiate measurements
avgRdfArray = newArray(arraySize);
maxRdfArray = newArray(arraySize);
minRdfArray = newArray(arraySize);
stdRdfArray = newArray(arraySize);
currentDiameter = radialStep;
makeOval(xCentroid-currentDiameter/2, yCentroid-currentDiameter/2, currentDiameter, currentDiameter);
getRawStatistics(nPixels, mean, min, max, std, histogram);
avgRdfArray[0] = mean;
maxRdfArray[0] = max;
minRdfArray[0] = min;
stdRdfArray[0] = std;
run("Select None");

//iterate rings in ROI manager
for (i=1;i<arraySize;i++){
	previousDiameter = currentDiameter;
	currentDiameter = currentDiameter+radialStep;
	selectRing(xCentroid,yCentroid,previousDiameter,currentDiameter);
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	avgRdfArray[i] = mean;
	maxRdfArray[i] = max;
	minRdfArray[i] = min;
	stdRdfArray[i] = std;
	run("Select None");
}

//Array.print(avgRdfArray);
//Array.print(maxRdfArray);
//Array.print(minRdfArray);
//Array.print(stdRdfArray);

Array.show("RDF Measurements: Average, Max, Min, Std", avgRdfArray, maxRdfArray, minRdfArray, stdRdfArray);