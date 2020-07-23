#!/bin/bash
set -e

clear

DATE="$(which date)"
TIMESTAMP=`$DATE '+%Y.%m.%d'`

export WORK_DIR=`pwd`

echo "Hello $USER, Please follow the on-screen prompts"
echo ""
echo "This script helps in creating and restoring backups of any drive"
echo ""
echo "Caution! Please be careful when restoring backups as you may easily"
echo "destroy your data. Ensure that you are writing to a correct drive!"
echo "You will need sudo in order to use this script"
echo ""
echo "The working folder is $WORK_DIR"
echo "To change directory quit the script, navigate to your"
echo "designated backup folder and run the script again"
echo ""
echo "Please select function:"
echo "b - Make a backup"
echo "r - Restore a backup"
echo "q - quit"
echo ""
read -p "What would you have me do (b/r/q) " PART

if [ $PART = b ]; then

    echo ""
    echo "This part will help you make a backup of a drive. Which one would you like"
    read -p "to clone? Please provide the letter of sdX " DRIVE_B
    echo ""
    echo "I will make a clone of /dev/sd${DRIVE_B}"
    echo ""
    echo "Output file will be named NAME_$TIMESTAMP.zip"
    read -p "What should I put as NAME? " NAMEB
    echo ""
    echo "The file will be named ${NAMEB}_${TIMESTAMP}.zip"
    echo ""
    echo "Starting the procedure. Please wait... this may take a while"

    sudo dd if=/dev/sd${DRIVE_B} of=${NAMEB}_${TIMESTAMP}.img bs=4M conv=noerror status=progress

    echo ""
    echo "Compressing ${NAMEB}_$TIMESTAMP.img. Please wait... this may take a while"
    zip ${NAMEB}_$TIMESTAMP.zip ${NAMEB}_$TIMESTAMP.img

    echo ""
    echo "Removing ${NAMEB}_$TIMESTAMP.img, we do not need that anymore"
    sudo rm ${NAMEB}_$TIMESTAMP.img

    SIZE="$(du -h ${NAMEB}_$TIMESTAMP.zip | awk '{ print $1 }')"

    echo ""
    echo "$USER, I finished. The file ${NAMEB}_$TIMESTAMP.zip is about $SIZE."
    echo "Full file path is ${WORK_DIR}/${NAMEB}_$TIMESTAMP.zip"

elif [ $PART = r ]; then

    echo ""
    echo "This part will help you restore a backup of a drive, it will be"
    echo "restored from the current directory. You will be asked to provide"
    echo "the file name of the backup that you want to restore and"
    echo "the letter of the drive that you want to write to"
    echo ""
    echo "The file name has the following pattern NAME_YYYY.MM.DD.zip"
    echo "You will be asked for parts of the name in the next step"
    echo ""
    echo "To which drive would you like to write?"
    read -p "Please provide the letter of sdX " DRIVE_R
    echo ""
    echo "Which file you want to use?"
    read -p "Please specify NAME part of the name " NAMER
    read -p "Please specify YYYY part of the name " YEAR
    read -p "Please specify MM   part of the name " MONTH
    read -p "Please specify DD   part of the name " DAY

    echo ""
    echo "Unzipping ${NAMER}_${YEAR}.${MONTH}.${DAY}.zip" 
    echo "Please wait... this may take a while"
    unzip ${NAMER}_${YEAR}.${MONTH}.${DAY}.zip

    echo ""
    echo "Writing image ${NAMER}_${YEAR}.${MONTH}.${DAY}.img to /dev/sd${DRIVE_R}"
    echo "Please wait... this may take a while"
    sudo dd if=${NAMER}_${YEAR}.${MONTH}.${DAY}.img of=/dev/sd${DRIVE_R} bs=4M conv=noerror status=progress

    echo ""
    echo "Removing ${NAMER}_${YEAR}.${MONTH}.${DAY}.img, we do not need that anymore"
    sudo rm ${NAMER}_${YEAR}.${MONTH}.${DAY}.img

    echo ""
    echo "$USER, I finished. Drive /dev/sd${DRIVE_R} is ready for use"

elif [ $PART = q ]; then

    echo ""
    echo "You have chosen to end the script"

else

    echo ""
    echo "Error! Wrong selection. Please note that selection is case sensitive."
    echo "Please run the script again and chose correct function."

fi

echo ""
echo "Thank you for using my services and have a good day!"
