import sys
from ij import IJ, ImagePlus, ImageStack
import fiji.plugin.trackmate.Settings as Settings
import fiji.plugin.trackmate.Model as Model
import fiji.plugin.trackmate.SelectionModel as SelectionModel
import fiji.plugin.trackmate.TrackMate as TrackMate
import fiji.plugin.trackmate.Logger as Logger
import fiji.plugin.trackmate.detection.DetectorKeys as DetectorKeys
from fiji.plugin.trackmate.detection import LogDetectorFactory
import fiji.plugin.trackmate.tracking.sparselap.SparseLAPTrackerFactory as SparseLAPTrackerFactory
import fiji.plugin.trackmate.tracking.LAPUtils as LAPUtils
import fiji.plugin.trackmate.visualization.hyperstack.HyperStackDisplayer as HyperStackDisplayer
import fiji.plugin.trackmate.features.FeatureFilter as FeatureFilter
import fiji.plugin.trackmate.features.FeatureAnalyzer as FeatureAnalyzer
import fiji.plugin.trackmate.features.spot.SpotContrastAndSNRAnalyzerFactory as SpotContrastAndSNRAnalyzerFactory
import fiji.plugin.trackmate.action.ExportStatsToIJAction as ExportStatsToIJAction
import fiji.plugin.trackmate.io.TmXmlReader as TmXmlReader
import fiji.plugin.trackmate.action.ExportTracksToXML as ExportTracksToXML
import fiji.plugin.trackmate.io.TmXmlWriter as TmXmlWriter
import fiji.plugin.trackmate.features.ModelFeatureUpdater as ModelFeatureUpdater
import fiji.plugin.trackmate.features.SpotFeatureCalculator as SpotFeatureCalculator
import fiji.plugin.trackmate.features.spot.SpotContrastAndSNRAnalyzer as SpotContrastAndSNRAnalyzer
import fiji.plugin.trackmate.features.spot.SpotIntensityAnalyzerFactory as SpotIntensityAnalyzerFactory
import fiji.plugin.trackmate.features.track.TrackSpeedStatisticsAnalyzer as TrackSpeedStatisticsAnalyzer
import fiji.plugin.trackmate.util.TMUtils as TMUtils
   
   
# Get currently selected image
#imp = WindowManager.getCurrentImage()
outputFile = "/Users/ayakimovich/Dropbox (LMCB)/Moona and Artur/analysis/trackmate_output.csv"
imp = IJ.openImage("/Users/ayakimovich/Dropbox (LMCB)/Moona and Artur/analysis/AlixKD_w2.tif")
#IJ.run("Super-Redundancy Denoiser", "spatial=50 frame=10 denoising=2 number=2 number=1 fast max=10 gain=0 offset=0 readout-noise=0");
# NanoJ: 59.2s: Estimated Gain=8.971858 Offset=493.7476 with Readout-Sigma=59.08754

print("number of frames is: "+str(imp.getStackSize()))
print("first channel is: "+str(imp.	getChannel()))
#imp.show()
IJ.run(imp, "Properties...", "channels=1 slices=1 frames="+str(imp.getStackSize())+" unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=5.0000")
IJ.run(imp, "Maximum 3D...", "x=2 y=2 z=2")
IJ.run(imp, "Median 3D...", "x=1 y=1 z=1")
#imp.show()
   
   
#-------------------------
# Instantiate model object
#-------------------------
   
model = Model()
   
# Set logger
model.setLogger(Logger.IJ_LOGGER)
   
#------------------------
# Prepare settings object
#------------------------
      
settings = Settings()
settings.setFrom(imp)
      
# Configure detector
settings.detectorFactory = LogDetectorFactory()
settings.detectorSettings = {
    DetectorKeys.KEY_DO_SUBPIXEL_LOCALIZATION : True,
    DetectorKeys.KEY_RADIUS : 5.,
    DetectorKeys.KEY_TARGET_CHANNEL : 1,
    DetectorKeys.KEY_THRESHOLD : 15.,
    DetectorKeys.KEY_DO_MEDIAN_FILTERING : True,
} 
    
# Configure tracker
settings.trackerFactory = SparseLAPTrackerFactory()
settings.trackerSettings = LAPUtils.getDefaultLAPSettingsMap()
settings.trackerSettings['LINKING_MAX_DISTANCE'] = 1.0
settings.trackerSettings['GAP_CLOSING_MAX_DISTANCE']=1.0
settings.trackerSettings['MAX_FRAME_GAP']= 2
   
# Add the analyzers for some spot features.
# You need to configure TrackMate with analyzers that will generate 
# the data you need. 
# Here we just add two analyzers for spot, one that computes generic
# pixel intensity statistics (mean, max, etc...) and one that computes
# an estimate of each spot's SNR. 
# The trick here is that the second one requires the first one to be in
# place. Be aware of this kind of gotchas, and read the docs. 
settings.addSpotAnalyzerFactory(SpotIntensityAnalyzerFactory())
settings.addSpotAnalyzerFactory(SpotContrastAndSNRAnalyzerFactory())
   
# Add an analyzer for some track features, such as the track mean speed.
settings.addTrackAnalyzer(TrackSpeedStatisticsAnalyzer())
   
settings.initialSpotFilterValue = 1
   
print(str(settings))
      
#----------------------
# Instantiate trackmate
#----------------------
   
trackmate = TrackMate(model, settings)
      
#------------
# Execute all
#------------
   
     
ok = trackmate.checkInput()
if not ok:
    sys.exit(str(trackmate.getErrorMessage()))
     
ok = trackmate.process()
if not ok:
    sys.exit(str(trackmate.getErrorMessage()))
     
      
      
#----------------
# Display results
#----------------
   
model.getLogger().log('Found ' + str(model.getTrackModel().nTracks(True)) + ' tracks.')
    
selectionModel = SelectionModel(model)
displayer =  HyperStackDisplayer(model, selectionModel, imp)
displayer.render()
displayer.refresh()
   
# The feature model, that stores edge and track features.
fm = model.getFeatureModel()
with open(outputFile, "w") as text_file:
	text_file.write('spot ID, x, y, t, quality, snr, mean_intensity')
	for id in model.getTrackModel().trackIDs(True):
	   
	    # Fetch the track feature from the feature model.
	    #v = fm.getTrackFeature(id, 'TRACK_MEAN_SPEED')
	    #model.getLogger().log('')
	    #model.getLogger().log('Track ' + str(id) + ': mean velocity = ' + str(v) + ' ' + model.getSpaceUnits() + '/' + model.getTimeUnits())
	       
	    track = model.getTrackModel().trackSpots(id)
	    for spot in track:
	        sid = spot.ID()
	        # Fetch spot features directly from spot. 
	        x=spot.getFeature('POSITION_X')
	        y=spot.getFeature('POSITION_Y')
	        t=spot.getFeature('POSITION_Z')
	        q=spot.getFeature('QUALITY')
	        snr=spot.getFeature('SNR') 
	        mean=spot.getFeature('MEAN_INTENSITY')
	        model.getLogger().log('\tspot ID = ' + str(sid) + ': x='+str(x)+', y='+str(y)+', t='+str(t)+', q='+str(q) + ', snr='+str(snr) + ', mean = ' + str(mean))
	        
	        text_file.write(str(sid)+","+ str(x)+","+str(y)+","+str(t)+","+str(q)+","+str(snr)+","+str(mean))