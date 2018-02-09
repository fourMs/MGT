# Musical Gestures Toolbox for Matlab

The Musical Gestures Toolbox (MGT) is a Matlab toolbox for analysing music-related body motion, using sets of audio, video and motion capture data as source material.

## Installation

*Important: The toolbox has mainly been tested on Windows, most recently with Matlab 2017a. A lot of things changed after Matlab 2015b, and we know that there are issues with running it on Mac and Linux. We are eager to get everything fixed, and we appreciate all help in finding (and fixing!) bugs.*

1. Ensure that you have the relevant Matlab dependencies installed: 

- Computer Vision System Toolbox
- Image Processing Toolbox

2. Install the dependencies: 

- [matlabPyrTools](http://se.mathworks.com/matlabcentral/fileexchange/52571-matlabpyrtools)
- [MoCap Toolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mocaptoolbox)
- [MIRtoolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mirtoolbox).

2. Add the files in the folder "source-code" to your Matlab path: under the "Home" section, click "set path". Click the "Add Folder" button and choose the "source-code" folder and finally click "save".

3. Try out the m-files in the examples folder. There are some test files (audio, video, mocap) in the "example_data" folder.

## Functions

The Musical Gestures Toolbox contains a set of functions for the analysis and visualization of video, audio, and mocap data. There are four categories of functions:

- Data input and edit functions
- Data preprocessing functions
- Visualization functions
- Middle and higher level feature extraction functions


## History

The toolbox builds on the [Musical Gestures Toolbox for Max](http://www.uio.no/english/research/groups/fourms/downloads/software/musicalgesturestoolbox/), which has been developed by [alexarje](https://github.com/alexarje) since 2004, and parts of it is currently embedded in the [Jamoma](http://www.jamoma.org) project.

The first version of the Musical Gestures Toolbox for Matlab was made by [benlyyan](https://github.com/benlyyan) as part of his M.Sc. thesis at the University of Oslo ([Video analysis of music-related body motion in Matlab](https://www.duo.uio.no/handle/10852/51118)), and is currently maintained by the [fourMs group](https://github.com/fourMs).
