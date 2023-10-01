# worddeafness
This is a repository of materials supporting analyses reported in a case report manuscript currently in revision, 'A case report on word deafness as a stage in aphasia recovery.' 

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
This contains data and code for postprocessing the functional MRI maps of the aforementioned manuscript.  The pipeline for deriving these maps is described in detail in the manuscript. Code was written for use in MATLAB 2019a for Linux OS. The script makes use of some additional custom scripts that are also included in the zip file. Users will need to specify a working directory and ensure the data files/scripts are in said directory prior to running the code. Copies of the postprocessed maps are also provided for reference without running the code (see .nii.gz files that end in "_top5_mip001" and "_combined"). Of note, the postprocessed images need to be rescaled from 10-20 in whatever software is being used for viewing (e.g., MRIcron).

Additionally, we have included smoothed and unsmoothed versions of the lesion mask and the skull-stripped three-dimensional T1 image for reference.

# worddeafness-narrparadigms
This contains data and code for reproducing the custom spoken and written narrative functional MRI paradigms of the aforementioned manuscript. The stimuli and script for running the paradigms are also included. The script was written for use on MATLAB 2019a for Linux OS and makes use of the Psychophysics toolbox. 

We also have included a script for creating the paradigm design and some of the stimuli (see worddeafness_fMRI_narr.m). Code was written for use in MATLAB 2019a for Linux OS. Users will need to specify a working directory and ensure the data files are in said directory prior to running the code.

The finalized versions of the paradigm designs and stimuli are also included for reference in the narr2 folder.

# additional resources
This case report used the Quick Aphasia Battery (Wilson et al., 2018), a brief aphasia battery; and Adaptive Language Mapping (Wilson et al., 2018; Yen et al., 2019), a MATLAB toolbox of validated functional MRI paradigms. Materials for both are freely available at https://langneurosci.org/qab and https://langneurosci.org/alm respectively.
