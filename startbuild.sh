file_name=$(find . -name "*.xcodeproj" -exec basename {} \; | awk -F. '{print $1}');

printf "\n"
echo ".::Archiving $file_name!::."
printf "\n"
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

echo " ╔═══════════════════════╗"
echo " ║ Done! You're all set! ║"
echo " ╚═══════════════════════╝"