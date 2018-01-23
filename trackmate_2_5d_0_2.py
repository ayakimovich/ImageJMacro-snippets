import os
import fiji.plugin.trackmate.Spot as Spot
import fiji.plugin.trackmate.Model as Model
import fiji.plugin.trackmate.Settings as Settings
import fiji.plugin.trackmate.TrackMate as TrackMate

import fiji.plugin.trackmate.detection.LogDetectorFactory as LogDetectorFactory

import fiji.plugin.trackmate.tracking.LAPUtils as LAPUtils
import fiji.plugin.trackmate.tracking.sparselap.SparseLAPTrackerFactory as SparseLAPTrackerFactory
import fiji.plugin.trackmate.extra.spotanalyzer.SpotMultiChannelIntensityAnalyzerFactory as SpotMultiChannelIntensityAnalyzerFactory

import ij. IJ as IJ
from ij.gui import GenericDialog
import java.io.File as File
import java.util.ArrayList as ArrayList

def writeMeasurements(model,outputFile,nChannels):
	IJ.log('TrackMate completed successfully.' )
	IJ.log( 'Found %d spots in %d tracks.' % ( model.getSpots().getNSpots( True ) , model.getTrackModel().nTracks( True ) ) )

	# Print results in the console.
	headerStr = '%10s %10s %10s %10s %10s %10s' % ( 'Spot_ID', 'Track_ID', 'Frame', 'X', 'Y', 'Z' )
	rowStr = '%10d %10d %10d %10.1f %10.1f %10.1f'
	
	for i in range( nChannels ):
		headerStr += ( ' %10s'  % ( 'C' + str(i+1) ) )
		rowStr += ( ' %10.1f' )
	with open(outputFile, "w") as text_file:
		IJ.log('\n')
		IJ.log( headerStr)
		text_file.write(headerStr+'\n')
		
		tm = model.getTrackModel()
		trackIDs = tm.trackIDs( True )
		for trackID in trackIDs:
			spots = tm.trackSpots( trackID )
	
			# Let's sort them by frame.
			ls = ArrayList( spots );
			ls.sort( Spot.frameComparator )
			
			for spot in ls:
				values = [  spot.ID(), trackID, spot.getFeature('FRAME'), \
					spot.getFeature('POSITION_X'), spot.getFeature('POSITION_Y'), spot.getFeature('POSITION_Z') ]
				for i in range( nChannels ):
					values.append( spot.getFeature( 'MEAN_INTENSITY%02d' % (i+1) ) )
					
				IJ.log( rowStr % tuple( values ) )
				text_file.write(rowStr % tuple( values )+"\n")


imp = IJ.openImage("/Users/ayakimovich/Dropbox (LMCB)/Moona and Artur/IEVorCEV/SCR1_170713_siRNA_Alix_B5surface.lif - SCR_1.tif");

targetChannel = 3 # target detection channel
dt = 1.0 # dalta t
radius = 0.25 # double
threshold = 10.0
frameGap = 1 # int
linkingMax = 0.2
closingMax = 0.2

#IJ.run(imp, "Deinterleave", "how=4");
#IJ.run(imp, "Merge Channels...", "c1=[AlixKD_all_chan.tif #2] c2=[AlixKD_all_chan.tif #1] c3=[AlixKD_all_chan.tif #4] c4=[AlixKD_all_chan.tif #3] create");
outputDir = "/Users/ayakimovich/Dropbox (LMCB)/Moona and Artur/analysis/"
if not os.path.exists(outputDir):
	os.makedirs(outputDir)
# Swap Z and T dimensions if T=1
dims = imp.getDimensions() # default order: XYCZT
IJ.log("Image dimensions are:")
IJ.log(str(dims[0])+", "+str(dims[1])+", "+str(dims[2])+", "+str(dims[3])+", "+str(dims[4]))

if (dims[4] == 1):
	IJ.log("Swapping dimensions...")
	imp.setDimensions(dims[2], dims[4], dims[3])
	dims = imp.getDimensions() # default order: XYCZT
	IJ.log("Current dimensions are:")
	IJ.log(str(dims[0])+", "+str(dims[1])+", "+str(dims[2])+", "+str(dims[3])+", "+str(dims[4]))

#IJ.run(imp, "Arrange Channels...", "new=4132");
# Get the number of channels 
nChannels = imp.getNChannels()
IJ.log("number of frames is: "+str(imp.getStackSize()))
IJ.log("target channel is: "+str(targetChannel))
IJ.log( 'Number of channels to measure %d' % nChannels)
# Setup settings for TrackMate
settings = Settings()
settings.setFrom( imp )
settings.dt = dt

# Spot analyzer: we want the multi-C intensity analyzer.
settings.addSpotAnalyzerFactory( SpotMultiChannelIntensityAnalyzerFactory() )

# Spot detector.
settings.detectorFactory = LogDetectorFactory()
settings.detectorSettings = settings.detectorFactory.getDefaultSettings()
settings.detectorSettings['RADIUS'] = radius
settings.detectorSettings['THRESHOLD'] = threshold
settings.detectorSettings['TARGET_CHANNEL'] = targetChannel

# Spot tracker.
settings.trackerFactory = SparseLAPTrackerFactory()
settings.trackerSettings = LAPUtils.getDefaultLAPSettingsMap()
settings.trackerSettings['MAX_FRAME_GAP']  = frameGap
settings.trackerSettings['LINKING_MAX_DISTANCE']  = linkingMax
settings.trackerSettings['GAP_CLOSING_MAX_DISTANCE']  = closingMax

# Run TrackMate and store data into Model.
model = Model()
trackmate = TrackMate(model, settings)

imp.close()

if not trackmate.checkInput() or not trackmate.process():
	IJ.log('Could not execute TrackMate: ' + str( trackmate.getErrorMessage() ) )
else:
	outputFile = outputDir+"_trackmate_output.csv"
	IJ.log('Writing TrackMate Measurements to: '+outputFile)
	writeMeasurements(model,outputFile,nChannels)
