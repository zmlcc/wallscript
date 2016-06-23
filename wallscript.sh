#!/bin/bash

#################################################################
# Check required programs are installed 
#################################################################
if which wget > /dev/null;
 then echo "wget Installed"
 else echo "wget Not Installed"
 exit
fi

if which feh > /dev/null;
 then echo "feh Installed"
 else echo "feh Not Installed"
 exit
fi

# default index
idx=0

while getopts "d:" arg
do
    case $arg in
        d)
            idx=$OPTARG
    esac
done


#################################################################
# Set some variables
#################################################################
directory=~/wallpaper/bing_wallpaper/
mkdir -p $directory

#Base Bing URL
bing="www.bing.com"

#What day to start from. 0 is the current day,1 the previous day, etc...
day="&idx=$idx"

#Number of images to get
#May change this script later to get more images and rotate between them
number="&n=1"

#Set market, other options are:
#"&mkt=zh-CN"
#"&mkt=ja-JP"
#"&mkt=en-AU"
#"&mkt=en-UK"
#"&mkt=de-DE"
#"&mkt=en-NZ"
#"&mkt=en-CA"
#"&mkt=en-US"
market="&mkt=zh-CN"

xmlURL=$bing"/HPImageArchive.aspx?format=xml"$day$number$market
echo $xmlURL

#Set resolution, other options are:
#"_1024x768"
#"_1280x720"
#"_1366x768"
#"_1920x1200"
resolution="_1366x768"

#The file extension for the Bing pic
extension=".jpg"

#The URL for the desired pic resolution
pic_desired=$bing$(echo $(wget -q -O - $xmlURL) | grep -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)$resolution$extension

#Form the URL for the default pic resolution
pic_default=$bing$(echo $(wget -q -O - $xmlURL) | grep -oP "<url>(.*)</url>" | cut -d ">" -f 2 | cut -d "<" -f 1)

#Set options in feh, other options are:
#--bg-tile
#--bg-center
#--bg-max
#--bg-fill
options="--bg-fill"

#default wallpaper
default_wallpaper=~/wallpaper/wallpaper.jpg

#################################################################
# Download the desired image resolution
# If it doesn't exist then download the default image resolution
#################################################################
if wget -q --spider "$pic_desired"
then
	pic_name=${pic_desired##*/}
	wget -q -O $directory$pic_name $pic_desired
else
	pic_name=${pic_default##*/}
	wget -q -O $directory$pic_name $pic_default
fi


#################################################################
# Set wallpaper to picture just donwloaded
#################################################################
unlink $default_wallpaper
ln -s $directory$pic_name $default_wallpaper
feh $options $default_wallpaper
echo "set wallpaper to "$directory$pic_name

