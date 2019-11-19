# Musical Gestures Toolbox for Matlab

The Musical Gestures Toolbox (MGT) is a Matlab toolbox for analysing music-related body motion, using sets of audio, video and motion capture data as source material.

## Installation

1. Many of the basic things work with a standard Matlab install, but to use all features you will also need these extra Matlab packages: 

    - Computer Vision System Toolbox
    - Image Processing Toolbox

2. Some of the functions build on code from these third-party toolboxes: 

    - [matlabPyrTools](https://github.com/LabForComputationalVision/matlabPyrTools/archive/master.zip)
    - [MoCap Toolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mocaptoolbox) 
    - [MIRtoolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mirtoolbox).

3. Add the files in the folder "source-code" to your Matlab path: under the "Home" section, click "set path". Click the "Add Folder" button and choose the "source-code" folder and finally click "save".

4. Try out the m-files in the examples folder. There are some test files (audio, video, mocap) in the "example_data" folder.

## Functions

The Musical Gestures Toolbox contains a set of functions for the analysis and visualization of video, audio, and mocap data. There are four categories of functions:

- Data input and edit functions
- Data preprocessing functions
- Visualization functions
- Middle and higher level feature extraction functions

## Tutorial

There is a more or less complete introduction to the main features in the software carpentry workshop [Quantitative Video analysis for Qualitative Research](https://alexarje.github.io/video-analysis-workshop/).


## History

The toolbox builds on the [Musical Gestures Toolbox for Max](http://www.uio.no/english/research/groups/fourms/downloads/software/musicalgesturestoolbox/), which has been developed by [alexarje](https://github.com/alexarje) since 2004, and parts of it is currently embedded in the [Jamoma](http://www.jamoma.org) project.

The first version of the Musical Gestures Toolbox for Matlab was made by [benlyyan](https://github.com/benlyyan) as part of his M.Sc. thesis at the University of Oslo ([Video analysis of music-related body motion in Matlab](https://www.duo.uio.no/handle/10852/51118)). 

There is now also a [Musical Gestures Toolbox for Python](https://github.com/fourMs/MGT-python).

The software is currently maintained by the [fourMs lab](https://github.com/fourMs) at [RITMO Centre for Interdisciplinary Studies in Rhythm, Time and Motion](https://www.uio.no/ritmo/english/) at the University of Oslo.

## Reference

If you use this toolbox for research purposes, please reference this publication: 

- Jensenius, Alexander Refsum (2018). [The Musical Gestures Toolbox for Matlab](http://hdl.handle.net/10852/65559). Proceedings of the 19th International Society for Music Information Retrieval Conference, Late Breaking Demos Session.

## Credits

Main developers: [Alexander Refsum Jensenius](http://people.uio.no/alexanje) and [Bo Shou](https://github.com/benlyyan).

## License

This software is open source, and is shared with [The GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).

