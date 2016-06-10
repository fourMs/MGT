
MGT is a music gestures toolbox which is useful to analyze video based music-related body motion. It has been developed in Matlab. Current vision requires Matlab 2015, and helpful toolboxes like matlabPyrtools, mocaptoolbox, mirtoolbox. 
This  repository includes data-set, example, source-code, MGT.zip, mirtoolbox.zip, mocaptoolbox.zip. User can choose to download .zip. 

1. In the data-set folder, the pianist data set contains the pianist.tsv, pianist.wav, pianist.mp4, which are related to mocap data, audio, video, respectively. This data set is used for illustration of how to use the MGT to analyze music-related motion. The corresponing demo can be found in the example folder. 

2. In the source-code, the functionalities of the MGT are listed, which are the same as the MGT.zip.

3. Mirtoolbox, Mocaptoolbox, matlabPyrtools are the helpful toolboxes. In order to use MGT, they need to be installed as well.

To install the MGT:

1. at first, download the MGT.zip and helpful toolboxes, put them in a directory and unzip them.

2. Launch your Matlab, enter the directory which contains the previous unzipped files. Run install.m in matlab command console. Note that if the helpful toolboxes have been installed in the matlab, you can simply install MGT like this: addpath('./MGT'), or you can by set path in the matlab "Home" section, find "set path" and click it. Then it opens a file selection dialog. Next, click the "Add Folder" and choose the unzipped folder and finally click "save". 

