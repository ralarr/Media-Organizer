# Created by relarr on 05/2015

#!/bin/bash

source ./final_library.sh
shopt -s extglob
cd /home/finalfiles/
logFunc
errorLogFunc

trap "cleanup" SIGINT SIGTERM

message="-- Options:
        -a              -create directories
        -c              -copy files to their respective directory
          -d              -debug mode
        -f              -move files to their respective directory
          -h              -print help and options
          -i              -install exiftool"

while getopts :acdfhi opt ;do

        case $opt in
                a)for file in *.@(JPG|jpg|mts)
                 do
                        if [ "$(exiftool -p '$dateTimeOriginal' -q  -f $file)" = "-" ]
                        then
                                dateFromStat
                                createDirectories
                        else
                                dateFromExif
                                createDirectories
                        fi
                 done;
                 for file in *.AVI
                 do
                        dateFromStat
                        createDirectories
                 done ;;

		c)for file in *.JPG
                do
                        if [ "$(exiftool -p '$dateTimeOriginal' -q  -f $file)" = "-" ]
                        then
                                dateFromStat
                                copyNoExif
                        else
                                count=1
                                dateFromExif
                                copyJPG
                        fi
                done;
                for file in *.jpg
                do
                        count=1
                        if [ "$(exiftool -p '$dateTimeOriginal' -q  -f $file)" = "-" ]
                        then
                                dateFromStat
                                copyNoExif
                        else
                                dateFromExif
                                copyJPG
                        fi
                done;

                for file in *.AVI
                do
                        dateFromStat
                        copyAVI
                done;
                for file in *.mts
                do
                        dateFromExif
                        copyMts
                done;;

                d)set -x ;;

		f)for file in *@(JPG|jpg)
                do
                        if [ "$(exiftool -p '$dateTimeOriginal' -q  -f $file)" = "-" ]
                        then
                                dateFromStat
                                moveNoExif
                        else
                                dateFromExif
                                moveJPG
                        fi
                done;
                for file in *.AVI
                do
                        dateFromStat
                        moveAVI
                done;
                for file in *.mts
                do
                        dateFromExif
                        moveMts
                done;;

                i)installFunc ;;

                h|*) echo "$message" ;;
        esac
done
shift $(($OPTIND -1))
