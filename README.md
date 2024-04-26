# worddeafness
This is a repository of materials supporting analyses in a case report manuscript, 'Situating word deafness within aphasia recovery: A case report', published in _Cortex_ [ https://doi.org/10.1016/j.cortex.2023.12.012 ].

This repository is currently archived as a means of sharing the files with the public in a read-only format. However, it is still actively maintained. Any questions concerning the analyses or code can be sent to: marianne.e.casilio@vanderbilt.edu.

Included here are three branches:

worddeafness-behavior
   
worddeafness-neuroimaging
   
worddeafness-narrparadigms

The contents of each branch are described below:

# worddeafness-behavior
This contains data and code for all of the behavioral data of the aforementioned manuscript. Code was written for use in R 4.3.0 for Mac OS. Users will need to specify a working directory and ensure the data file is in said directory prior to running the code.

We also provide data on item-level performance from all of the linguistic/nonlinguistic measures and the functional MRI paradigms (see worddeafness_itemscores1.csv and worddeafness_itemscores2.csv). In certain cases, we have omitted information about the target item for a given test for proprietary/copyright issues. 

# worddeafness-neuroimaging
This contains data and code for postprocessing the functional MRI maps of the aforementioned manuscript.  The pipeline for deriving these maps is described in detail in the manuscript and with reference to other relevant studies, all of which are freely available at https://langneurosci.org/publications/. Code was written for use in MATLAB 2019a for Linux OS. The script makes use of some additional custom scripts that are also included in the zip file. Users will need to specify a working directory and ensure the data files/scripts are in said directory prior to running the code. Copies of the postprocessed maps are also provided for reference without running the code (see .nii.gz files that end in "_top5_mip001" and "_combined"). The postprocessed images do need to be rescaled from 10-20 in whatever software is being used for viewing (e.g., MRIcron). Finally, we noticed that MATLAB 2023a for Mac OS requires that image files be unzipped prior to being read and this may be the case for other MATLAB versions or OS; thus, if the code returns an error related to reading in the files, we recommend first unzipping and then augmenting the code to read in the .nii files.

Additionally, we have included smoothed and unsmoothed versions of the lesion mask and the skull-stripped three-dimensional T1 image for reference.

# worddeafness-narrparadigms
This contains data and code for reproducing the custom spoken and written narrative functional MRI paradigms of the aforementioned manuscript. The stimuli and script for running the paradigms are also included. The script was written for use on MATLAB 2019a for Linux OS and makes use of the Psychophysics toolbox. The finalized versions of the paradigm designs and stimuli are also included.

We also have included a script for creating the paradigm design and some of the stimuli (see worddeafness_fMRI_narr.m). Code was written for use in MATLAB 2019a for Linux OS. Users will need to specify a working directory and ensure the data files are in said directory prior to running the code. As noted above, we noticed that MATLAB 2023a for Mac OS requires that image files be unzipped prior to being read and this may be the case for other MATLAB versions or OS; thus, if the code returns an error related to reading in the files, we recommend first unzipping and then augmenting the code to read in the .nii files.

# additional resources
This case report used the Quick Aphasia Battery (Wilson et al., 2018), a brief aphasia battery; and Adaptive Language Mapping (Wilson et al., 2018; Yen et al., 2019), a MATLAB toolbox of validated functional MRI paradigms. Materials for both are freely available at https://langneurosci.org/qab and https://langneurosci.org/alm respectively.
