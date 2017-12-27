# Musical Gestures Toolbox for Matlab

The Musical Gestures Toolbox (MGT) is a Matlab toolbox for analysing music-related body motion, using sets of audio, video and motion capture data as source material.

The current version is developed with Matlab 2015b, and builds on some other Matlab toolboxes:

- [matlabPyrTools](http://se.mathworks.com/matlabcentral/fileexchange/52571-matlabpyrtools)
- [MoCap Toolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mocaptoolbox)
- [MIRtoolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mirtoolbox)

It also requires the following MathWorks toolboxes: 

- Computer Vision System Toolbox
- Image Processing Toolbox

## Installation

*Important: A lot of things changed between Matlab versions 2015b and 2016a (and later). For now, the toolbox works best with 2015b (and prior). Parts of it probably also works with later versions, and we are eager to get everything updated to the latest version. Sorry for the inconvenience, and we appreciate all help in fixing bugs.*

1. Install the dependencies: [matlabPyrTools](http://se.mathworks.com/matlabcentral/fileexchange/52571-matlabpyrtools), [MoCap Toolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mocaptoolbox) and [MIRtoolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mirtoolbox).

2. Add the files in the folder "source-code" to your Matlab path: under the "Home" section, click "set path". Click the "Add Folder" button and choose the "source-code" folder and finally click "save".

3. Try out the m-files in the examples folder. There are some test files (audio, video, mocap) in the "example_data" folder.

## Functions

The Musical Gestures Toolbox contains a set of functions for the analysis and visualization of video, audio, and mocap data. There are four categories of functions:

- Data input and edit functions
- Data preprocessing functions
- Visualization functions
- Middle and higher level feature extraction functions

## Data Structures

The Musical Gestures Toolbox uses only one `struct` data structure. This structure contains three fields: video, audio, and mocap, which corresponds to these three types of data, respectively. An MGT data structure is created with the function:

    mg=mginitstruct;

This produces a structure `mg` with three fields. The video field (mg.video) contains data and general parameters of the video file:

- .obj: stores each frame of the video
- .gram: after running the function `mgmotion`, motiongram data are written to `.gram.x` and `.gram.y`.
- .qom: quantity of motion of each frame
- .com: centroid of motion of each frame
- .nframe: the number of frames in the video file. The framerate of the video is stored in the field framerate. This is most often 25 or 30 frames per second. Duration field is for length of the video.
- .method: the toolbox uses two general methods to estimate the motion: either based on frame differencing ('Diff') or optical flow ('OpticalFlow').

The data structures for mocap and audio are copied from the [MoCap](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mocaptoolbox)
and [MIR](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mirtoolbox) toolboxes.


## History

The toolbox builds on the [Musical Gestures Toolbox for Max](http://www.uio.no/english/research/groups/fourms/downloads/software/musicalgesturestoolbox/), which has been developed by [alexarje](https://github.com/alexarje) since 2004, and parts of it is currently embedded in the [Jamoma](http://www.jamoma.org) project.

The first version of the Musical Gestures Toolbox for Matlab was made by [benlyyan](https://github.com/benlyyan) as part of his M.Sc. thesis at the University of Oslo ([Video analysis of music-related body motion in Matlab](https://www.duo.uio.no/handle/10852/51118)), and is currently maintained by the [fourMs group](https://github.com/fourMs).
