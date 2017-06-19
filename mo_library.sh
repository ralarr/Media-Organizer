# Created by ralarr on 05/2015

#!/bin/bash

logFunc()
{
        exec > >( tee -a /home/final.log|logger -s -t $(basename $0) )
}

errorLogFunc()
{
        exec 2> >( tee -a /home/final-error.log|logger -s -t $(basename $0) >&2 )
}

installFunc()
{
        echo "Install exiftool? y/n?: "
        read user
                if [ $user = y ]
        then
                sudo yum install exiftool
        else
                echo "ok"
        fi
}

cleanup()
{
        echo "exiting..."
        sleep 1
        exit
}

dateFromExif()
{
        VAR="$(exiftool -p '$dateTimeOriginal' -q  -f $file|sed 's/:/-/g; s/ /_/g')"
        year=${VAR%%-*};VAR=${VAR#*-}
        month=${VAR%%-*};VAR=${VAR#*-}
        day=${VAR%%_*};VAR=${VAR#*_}
}

dateFromStat()
{
        jVAR="$(stat -c %y "$file")"
        year=${jVAR%%-*};jVAR=${jVAR#*-}
        month=${jVAR%%-*};jVAR=${jVAR#*-}
        day=${jVAR%% *};jVAR=${jVAR#* }
}

createDirectories()
{
        echo "creating directory ./Photos/$year/$month/$day..."
        mkdir -p ./Photos/$year/$month/$day/
}

copyJPG()
{
        make=$(exiftool -p '$model' -q  -f $file|sed 's/ /_/g')
        ndate=$(exiftool -p '$dateTimeOriginal' -q  -f $file|sed 's/:/-/g; s/ /_/g')

        if [[ ! -e "./Photos/$year/$month/$day/${ndate}_$make.jpg" ]]
        then
                cp "$file" "./Photos/$year/$month/$day/${ndate}_$make.jpg"
                echo "copying $file to ./Photos/$year/$month/$day..."
        else
                if ! [[ $(md5sum "$file" | cut -d ' ' -f 1) == $(md5sum "./Photos/$year/$month/$day/${ndate}_$make.jpg" | cut -d ' ' -f 1) ]]
                then
                        echo "different checksum"
                        (( count++ ))
                        cp "$file" "./Photos/$year/$month/$day/${ndate}_${make}_$count.jpg"
                        echo "copying $file to ./Photos/$year/$month/$day..."
                fi
        fi
}

copyNoExif()
{
        umake="Unknown"
        sdate=$(stat -c %y "$file"|awk -F. '{print $1}')

        if [[ ! -e "./Photos/$year/$month/$day/${sdate}_$umake.jpg" ]]
        then
                cp "$file" "./Photos/$year/$month/$day/${sdate}_$umake.jpg"
                echo "copying $file to ./Photos/$year/$month/$day..."
        else
                if ! [[ $(md5sum "$file" | cut -d ' ' -f 1) == $(md5sum "./Photos/$year/$month/$day/${sdate}_$umake.jpg" | cut -d ' ' -f 1) ]]
                then
                        echo "different checksum"
                        (( count++ ))
                        cp "$file" "./Photos/$year/$month/$day/${sdate}_${umake}_$count.jpg"
                        echo "copying $file to ./Photos/$year/$month/$day..."
                fi
        fi
}

copyAVI()
{
        Amake="Unknown"
        Adate=$(stat -c %y "$file"|awk -F. '{print $1}')

        if [[ ! -e "./Photos/$year/$month/$day/${Adate}_$Amake.jpg" ]]
        then
                cp "$file" "./Photos/$year/$month/$day/${Adate}_$Amake.jpg"
                echo "copying $file to ./Photos/$year/$month/$day..."
        else
                if ! [[ $(md5sum "$file" | cut -d ' ' -f 1) == $(md5sum "./Photos/$year/$month/$day/${Adate}_$Amake.jpg" | cut -d ' ' -f 1) ]]
                then
                        echo "different checksum"
                        (( count++ ))
                        cp "$file" "./Photos/$year/$month/$day/${Adate}_${Amake}_$count.jpg"
                        echo "copying $file to ./Photos/$year/$month/$day..."
                fi
        fi
}

copyMts()
{
        mmake=$(exiftool -p '$model' -q  -f $file|sed 's/ /_/g')
        mdate=$(exiftool -p '$dateTimeOriginal' -q  -f $file|sed 's/:/-/g; s/ /_/g')

        if [[ ! -e "./Photos/$year/$month/$day/${mdate}_$mmake.jpg" ]]
        then
                cp "$file" "./Photos/$year/$month/$day/${mdate}_$mmake.jpg"
                echo "copying $file to ./Photos/$year/$month/$day..."
        else
                if ! [[ $(md5sum "$file" | cut -d ' ' -f 1) == $(md5sum "./Photos/$year/$month/$day/${mdate}_$mmake.jpg" | cut -d ' ' -f 1) ]]
                then
                        echo "different checksum"
                        (( count++ ))
                        cp "$file" "./Photos/$year/$month/$day/${mdate}_${mmake}_$count.jpg"
                        echo "copying $file to ./Photos/$year/$month/$day..."
                fi
        fi
}

moveJPG()
{
        make=$(exiftool -p '$model' -q  -f $file|sed 's/ /_/g')
        ndate=$(exiftool -p '$dateTimeOriginal' -q  -f $file|sed 's/:/-/g; s/ /_/g')

        if [[ ! -e "./Photos/$year/$month/$day/${ndate}_$make.jpg" ]]
        then
                mv "$file" "./Photos/$year/$month/$day/${ndate}_$make.jpg"
                echo "moving $file to ./Photos/$year/$month/$day..."
        else
                if ! [[ $(md5sum "$file" | cut -d ' ' -f 1) == $(md5sum "./Photos/$year/$month/$day/${ndate}_$make.jpg" | cut -d ' ' -f 1) ]]
                then
                        echo "different checksum"
                        (( count++ ))
                        mv "$file" "./Photos/$year/$month/$day/${ndate}_${make}_$count.jpg"
                        echo "moving $file to ./Photos/$year/$month/$day..."
                fi
        fi
}

moveNoExif()
{
        umake="Unknown"
        sdate=$(stat -c %y "$file"|awk -F. '{print $1}')

        if [[ ! -e "./Photos/$year/$month/$day/${sdate}_$umake.jpg" ]]
        then
                mv "$file" "./Photos/$year/$month/$day/${sdate}_$umake.jpg"
                echo "moving $file to ./Photos/$year/$month/$day..."
        else
                if ! [[ $(md5sum "$file" | cut -d ' ' -f 1) == $(md5sum "./Photos/$year/$month/$day/${sdate}_$umake.jpg" | cut -d ' ' -f 1) ]]
                then
                        echo "different checksum"
                        (( count++ ))
                        mv "$file" "./Photos/$year/$month/$day/${sdate}_${umake}_$count.jpg"
                        echo "moving $file to ./Photos/$year/$month/$day..."
                fi
        fi
}

moveAVI()
{
        Amake="Unknown"
        Adate=$(stat -c %y "$file"|awk -F. '{print $1}')

        if [[ ! -e "./Photos/$year/$month/$day/${Adate}_$Amake.jpg" ]]
        then
                mv "$file" "./Photos/$year/$month/$day/${Adate}_$Amake.jpg"
                echo "moving $file to ./Photos/$year/$month/$day..."
        else
                if ! [[ $(md5sum "$file" | cut -d ' ' -f 1) == $(md5sum "./Photos/$year/$month/$day/${Adate}_$Amake.jpg" | cut -d ' ' -f 1) ]]
                then
                        echo "different checksum"
                        (( count++ ))
                        mv "$file" "./Photos/$year/$month/$day/${Adate}_${Amake}_$count.jpg"
                        echo "moving $file to ./Photos/$year/$month/$day..."
                fi
        fi
}

moveMts()
{
        mmake=$(exiftool -p '$model' -q  -f $file|sed 's/ /_/g')
        mdate=$(exiftool -p '$dateTimeOriginal' -q  -f $file|sed 's/:/-/g; s/ /_/g')

        if [[ ! -e "./Photos/$year/$month/$day/${mdate}_$mmake.jpg" ]]
        then
                mv "$file" "./Photos/$year/$month/$day/${mdate}_$mmake.jpg"
                echo "moving $file to ./Photos/$year/$month/$day..."
        else
                if ! [[ $(md5sum "$file" | cut -d ' ' -f 1) == $(md5sum "./Photos/$year/$month/$day/${mdate}_$mmake.jpg" | cut -d ' ' -f 1) ]]
                then
                        echo "different checksum"
                        (( count++ ))
                        mv "$file" "./Photos/$year/$month/$day/${mdate}_${mmake}_$count.jpg"
                        echo "moving $file to ./Photos/$year/$month/$day..."
                fi
        fi
}
