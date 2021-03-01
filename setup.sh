echo "\n----- Starting a new iOS application -----\n\n"
echo "Enter app name (e.g. new-app): "
read newname
testNewName=${newname//-/_} #replace "-" characters with "_"

rm -rf Pods/
mkdir "../$newname"
cp -r ./ "../$newname"
cd "../$newname"
mv README-TEMPLATE.md README.md

# oldname="boilerplate-ios"
# sed -i "" "s/$oldname/$newname/g" ./project.yml
# sed -i "" "s/$oldname/$newname/g" ./Podfile
# find . -type f -name "Podfile" -exec sed -i "" "/target 'junglerocks-ios' do/,/end/d" {} \; #Remove junglerocks-ios mentions on Podfile
# sed -i "" "s/$oldname/$newname/g" ./fastlane/Fastfile
# find . -type f -name "*.swift" -exec sed -i "" "s/$oldname/$newname/g" {} \; #Rename boilerplate mentions on swift files
# find . -type f -name "*.strings" -exec sed -i "" "s/$oldname/$newname/g" {} \; #Rename boilerplate mentions on string files
# find . -type f -name "*.xcconfig" -exec sed -i "" "s/$oldname/$newname/g" {} \; #Rename boilerplate mentions on config files
# sed -i "" "s/$oldname/$newname/g" ./README.md

# testOldName="boilerplate_ios"
# find . -type f -name "*.swift" -exec sed -i "" "s/$testOldName/$testNewName/g" {} \; #Rename boilerplate name on test files
cd "ios/"
rm -rf .git *.xcworkspace *.xcodeproj XcodeTemplates/
rm Podfile.lock
rm setup.sh
rm README.md

xcodegen
pod install
rm project.yml