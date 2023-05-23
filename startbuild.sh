# Ask for choice input
# echo "### Select project type"
# echo " [1] : .xcodeproj (default)"
# echo " [2] : .xcworkspace (cocoapods type)"
# read choice

# Define functions
function testing() {
    # find_file=$(find . -name "*.xcodeproj");
    find_file=$(find . -name "*.xcodeproj" -exec basename {} \;);
    # file_name=$(find . -name "*.xcworkspace" -exec basename {} \; | awk -F. '{print $1}');
    file_name=($find_file) | awk -F. '{print $1}';
    echo "find name is $find_file"
    echo "file_name is $file_name"
    if [ -z "$file_name" ]; then
        echo 'cant find file name'
        return;
    else
        echo 'found file name'
    fi

    echo 'this is after if else'

}

testing

function xcodeproj() {
    file_name=$(find . -name "*.xcodeproj" -exec basename {} \; | awk -F. '{print $1}');

    printf "\n"
    echo ".::Archiving $file_name.xcodeproj!::."
    printf "\n"

    xcodebuild archive \
    -project $file_name.xcodeproj \
    -scheme $file_name \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "archives/$file_name-ios" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

    xcodebuild archive \
    -project $file_name.xcodeproj \
    -scheme $file_name \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "archives/$file_name-simulator" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

    xcodebuild -create-xcframework \
    -archive archives/$file_name-ios.xcarchive -framework $file_name.framework \
    -archive archives/$file_name-simulator.xcarchive -framework $file_name.framework \
    -output archives/$file_name.xcframework;
}

function xcworkspace() {
    file_name=$(find . -name "*.xcworkspace" -exec basename {} \; | awk -F. '{print $1}');
    printf "\n"
    echo ".::Archiving $file_name.xcworkspace!::."
    printf "\n"

    xcodebuild archive \
    -workspace $file_name.xcworkspace \
    -scheme $file_name \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "archives/$file_name-ios" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

    xcodebuild archive \
    -workspace $file_name.xcworkspace \
    -scheme $file_name \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "archives/$file_name-simulator" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

    xcodebuild -create-xcframework \
    -archive archives/$file_name-ios.xcarchive -framework $file_name.framework \
    -archive archives/$file_name-simulator.xcarchive -framework $file_name.framework \
    -output archives/$file_name.xcframework;
}

# Check the choice and execute corresponding function
# if [ "$choice" = "1" ]; then
#     xcodeproj
# elif [ "$choice" = "2" ]; then
#     xcworkspace
# else
#     xcodeproj
# fi

# Closing
echo "output is in 'archives' folder"
echo " ╔═══════════════════════╗"
echo " ║ Done! You're all set! ║"
echo " ╚═══════════════════════╝"

# printf "\n"
# echo ".::Archiving $file_name!::."
# printf "\n"
# printf "\n"

# xcodebuild archive \
# -project $file_name.xcodeproj \
# -scheme $file_name \
# -configuration Release \
# -destination "generic/platform=iOS" \
# -archivePath "archives/$file_name-ios" \
# SKIP_INSTALL=NO \
# BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

# xcodebuild archive \
# -project $file_name.xcodeproj \
# -scheme $file_name \
# -configuration Release \
# -destination "generic/platform=iOS Simulator" \
# -archivePath "archives/$file_name-simulator" \
# SKIP_INSTALL=NO \
# BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

# xcodebuild -create-xcframework \
# -archive archives/$file_name-ios.xcarchive -framework $file_name.framework \
# -archive archives/$file_name-simulator.xcarchive -framework $file_name.framework \
# -output archives/$file_name.xcframework;

# echo " ╔═══════════════════════╗"
# echo " ║ Done! You're all set! ║"
# echo " ╚═══════════════════════╝"


#!/bin/bash

# Find the file in the current folder
file_path=$(find . -maxdepth 1 -type f -name "filename.*")

if [ -f "$file_path" ]; then
    # Extract the file name without extension
    file_name=$(basename -s .extension "$file_path")
    echo "File found: $file_name"
else
    echo "File not found."
fi

#!/bin/bash

# Define the function with parameters
my_function() {
    local param1=$1
    local param2=$2

    echo "Parameter 1: $param1"
    echo "Parameter 2: $param2"
}

# Call the function with arguments
my_function "Hello" "World"