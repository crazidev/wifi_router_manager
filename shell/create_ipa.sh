#!/bin/bash
# Author: Crazibeat
# this batch script converts IOS Runner.app in the flutter build folder to ios archive ipa
# when you use this command with flutter run, flutter will use to install prebuild ipa and start debugginga without building application all over from scratch
# example: flutter run --use-application-binary=build/ios/iphoneos/payload.ipa

GREEN='\033[0;32m'
RED='\033[0;31m'
DIR="$(pwd)/"

if ! [ -d "build/ios/iphoneos/Runner.app" ]; then
    echo -e "${GREEN}Switching Back to root folder"
    cd ".."
    DIR="$(pwd)/"
fi

if [ -d "build/ios/iphoneos/Runner.app" ]; then
    echo -e "${GREEN}Creating payload folder"
    mkdir ${DIR}build/ios/iphoneos/payload

    # check if payload folder was created
    if [ -d "${DIR}build/ios/iphoneos/payload" ]; then
        echo -e "${GREEN}Copy Runner.app to payload folder"
        cp -r ${DIR}build/ios/iphoneos/Runner.app ${DIR}build/ios/iphoneos/payload/Runner.app

        # check if Runner.app folder exist in payload folder
        if [ -d "${DIR}build/ios/iphoneos/payload/Runner.app" ]; then
            echo -e "${GREEN}Zipping payload folder to payload.ipa"
            cd ${DIR}build/ios/iphoneos/
            zip -rq1 payload.ipa payload/

            # delete temporary foler
            echo -e "${GREEN}Cleaning up"
            rm -rf ${DIR}build/ios/iphoneos/payload

            # check if payload.ipa exist
            if [ -f "payload.ipa" ]; then
                echo -e "${GREEN}IOS archive file generated successfully $(pwd)/payload.ipa"
            else
                echo -e "${RED}archive file not found"
            fi

        else
            echo -e "${RED}Runner.app was not copied into payload folder"
        fi

    else
        echo -e "${RED}Creating folder failed"
    fi

else
    echo -e "${RED}Couldn't locate ${DIR}build/ios/iphoneos/Runner.app"
fi

# ========  result of script =========
# Creating payload folder
# Copy Runner.app to payload folder
# Zipping payload folder to payload.ipa
# Cleaning up
# IOS archive file generated successfully /Users/crazidev/Development/flutter-projects/AZCpay_project/build/ios/iphoneos/payload.ipa
