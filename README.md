# Musical Gestures Toolbox for Matlab

The Musical Gestures Toolbox (MGT) is a Matlab toolbox for analysing music-related body motion, using sets of audio, video and motion capture data as source material.

The current version is developed with Matlab 2015b, and builds on some other Matlab toolboxes:

- [matlabPyrTools](http://se.mathworks.com/matlabcentral/fileexchange/52571-matlabpyrtools)
- [MoCap Toolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mocaptoolbox)
- [MIRtoolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mirtoolbox)

## Installation

*Important: A lot of things changed between Matlab versions 2015b and 2016a (and later). For now, the toolbox works best with 2015b (and prior). Parts of it probably also works with later versions, and we are eager to get everything updated to the latest version. Sorry for the inconvenience, and we appreciate all help in fixing bugs.*

1. Install the dependencies: [matlabPyrTools](http://se.mathworks.com/matlabcentral/fileexchange/52571-matlabpyrtools), [MoCap Toolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mocaptoolbox) and [MIRtoolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mirtoolbox).

2. Add the files in the folder "source-code" to your Matlab path: under the "Home" section, click "set path". Click the "Add Folder" button and choose the "source-code" folder and finally click "save".

3. Start using the toolbox.

## Usage

There are some test files (audio, video, mocap) in the "data" folder. Try out the m-files in the examples folder.

## History

The toolbox builds on the [Musical Gestures Toolbox for Max](http://www.uio.no/english/research/groups/fourms/downloads/software/musicalgesturestoolbox/), which has been developed by [alexarje](https://github.com/alexarje) since 2004, and parts of it is currently embedded in the [Jamoma](http://www.jamoma.org) project.

The first version of the Musical Gestures Toolbox for Matlab was made by [benlyyan](https://github.com/benlyyan) as part of his M.Sc. thesis at the University of Oslo ([Video analysis of music-related body motion in Matlab](https://www.duo.uio.no/handle/10852/51118)), and is currently maintained by the [fourMs group](https://github.com/fourMs).
