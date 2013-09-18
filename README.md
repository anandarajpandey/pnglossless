pnglossless
===========

Lossyless compression of png - perl script
scripts will find png files inside the folders recursivly and does the lossyless compression, copy of original files will 
be saved in given backup folder. Make sure backup folder is not inside the main image folder.



Tool for optimizing PNG  files.

requires optipng,advancecomp and png crush


Installing optipng: 
Binaries installation

Installing advancecomp
Linux - Debian/Ubuntu

sudo apt-get install advancecomp 


Linux - RHEL/Fedora/Centos

sudo yum install -y advancecomp 


Installing pngcrush
cd /tmp
curl -O http://iweb.dl.sourceforge.net/project/pmt/pngcrush/1.7.43/pngcrush-1.7.43.tar.gz
tar zxf pngcrush-1.7.43.tar.gz
cd pngcrush-1.7.43
make 

Insalling optipng
cd /tmp
curl -O http://prdownloads.sourceforge.net/optipng/optipng-0.7.4.tar.gz?download
tar zxf optipng-0.7.4.tar.gz
cd optipng-0.7.4.tar.gz
make


USUAGE
[filemape].pl [source] [backup]


