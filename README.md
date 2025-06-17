# MClust_TrodesEpochs
MClust is a Matlab-based spike sorting toolbox for the separation of putative cells from multi-site neurophysiological recordings.  It is particularly good for tetrodes.

Forked from v4.4.07 12/2024

This version is meant for in-house use on Trodes data where epochs are recorded separately and spike data are extracted into separate subfolders (e.g., rest1, behavior, rest2)

The main changes are the tetrode Loading Function along with some minor edits to RunClustBatch (now RunClustBatch_epoch) and a few interface operations that allow the FD file folders to use a different name from the individual spike data (.dat) files. 

Instructions:
1) Create a folder for the recording session and place the three other folders (r1, merged/bhvr, r2) within
2) If spike extraction has not yet been done (Note: spike extraction should be straightforward in Matlab but our current version creates errors.) 
  A) load each rec file in trodes and adjust the thresholds so that they are high enough to remove noise, but low enough to catch the cells. Make sure the thresholds are the same for each epoch.
  B) Before exiting trodes, select "export" and choose "spikes". This will create the spikes folder within the epoch subfolder (e.g., _r1.spikes, merged.spikes, etc)
3) Make sure you have MClust downloaded and include all MClust folders in your Matlab paths.
4) You may want to have Trodes downloaded from the SpikeGadgets site (https://spikegadgets.com/trodes/) and to set your path to include the TrodesToMatlab folder. The readTrodesExtractedDataFile.m function is now included in this MClust package, but there may be other dependencies that are required.
5) Before run-batching, make sure Matlab is currently in the session folder (the folder above the epoch folders). This is unfortunately important now--will fix in the future
6) Type "RunClustBatch_epoch" into Matlab

Importantly: all t-files generated from this version of MClust will use a new set of timestamps, where the record start time of the first recorded epoch will be the "zero" time. Video frame, user entries, and LFP timestamps should also be adjusted accordingly. 
