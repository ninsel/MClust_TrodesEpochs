# MClust_TrodesEpochs
MClust is a Matlab-based spike sorting toolbox for the separation of putative cells from multi-site neurophysiological recordings.  It is particularly good for tetrodes.

Forked from v4.4.07 12/2024

This version is meant for in-house use on Trodes data where epochs are recorded separately and spike data are extracted into separate subfolders (e.g., rest1, behavior, rest2)

The main changes are the tetrode Loading Function along with some minor edits to RunClustBatch (now RunClustBatch_epoch) and a few interface operations that allow the FD file folders to use a different name from the individual spike data (.dat) files. 

