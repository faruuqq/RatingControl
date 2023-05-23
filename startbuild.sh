Ask for choice input
echo "### Select project type"
echo " [1] : .xcodeproj (default)"
echo " [2] : .xcworkspace (cocoapods type)"
read choice

# Define functions
function findFile() {
    local param=$1

    printf "\n"

    file_path=$(find . -maxdepth 1 -type d -name "*.$param")
    if [ -d "$file_path" ]; then
        # Extract the file name without extension
        file_name=$(basename "$file_path")
        file_name_without_extension="${file_name%.*}"
        echo "File found: $file_name_without_extension.$param"
        
        if [ "$param" = "xcodeproj" ]; then
            xcodeproj $file_name_without_extension
        elif [ "$param" = "xcworkspace" ]; then
            xcworkspace $file_name_without_extension
        else
            xcodeproj
        fi

        closing
    else
        echo "File not found."
        echo "Please ensure the 'startarchive.sh' is in the same folder with 'xcodeproj' or 'xcworkspace'."
    fi

    printf "\n"
}

function xcodeproj() {
    local found_file=$1

    printf "\n"
    echo ".::Archiving $found_file.xcodeproj!::."
    printf "\n"

    xcodebuild archive \
    -project $found_file.xcodeproj \
    -scheme $found_file \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "Archives/$found_file-ios" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

    xcodebuild archive \
    -project $found_file.xcodeproj \
    -scheme $found_file \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "Archives/$found_file-simulator" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

    xcodebuild -create-xcframework \
    -archive Archives/$found_file-ios.xcarchive -framework $found_file.framework \
    -archive Archives/$found_file-simulator.xcarchive -framework $found_file.framework \
    -output Archives/$found_file.xcframework;
}

function xcworkspace() {
    local found_file=$1

    printf "\n"
    echo ".::Archiving $found_file.xcworkspace!::."
    printf "\n"

    xcodebuild archive \
    -workspace $found_file.xcworkspace \
    -scheme $found_file \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "Archives/$found_file-ios" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

    xcodebuild archive \
    -workspace $found_file.xcworkspace \
    -scheme $found_file \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "Archives/$found_file-simulator" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

    xcodebuild -create-xcframework \
    -archive Archives/$found_file-ios.xcarchive -framework $found_file.framework \
    -archive Archives/$found_file-simulator.xcarchive -framework $found_file.framework \
    -output Archives/$found_file.xcframework;
}

function closing() {
    echo "output is in 'Archives' folder"
    echo " ╔═══════════════════════╗"
    echo " ║ Done! You're all set! ║"
    echo " ╚═══════════════════════╝"
}

# Check the choice and execute corresponding function
if [ "$choice" = "1" ]; then
    findFile "xcodeproj"
elif [ "$choice" = "2" ]; then
    findFile "xcworkspace"
else
    findFile "xcodeproj"
fi
