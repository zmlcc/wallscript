#!/bin/bash
#################################################################
#Ver.	Date		Name		Description		#
#v0.1	2014-12-07	Marchione	Initial script		#
#								#
#								#
#################################################################

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

#################################################################
# Set some variables
#################################################################
directory=~/wallpapers/bing/
mkdir $directory

#Base Bing URL
bing="www.bing.com"

#What day to start from. 0 is the current day,1 the previous day, etc...
day="&idx=0"

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
market="&mkt=en-US"

xmlURL=$bing"/HPImageArchive.aspx?format=xml"$day$number$market

#Set resolution, other options are:
#"_1024x768"
#"_1280x720"
#"_1366x768"
#"_1920x1200"
resolution="_1920x1080"

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
options="--bg-scale"

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
# Set wallpaper in feh
#################################################################
feh $options $directory$pic_name
exit
