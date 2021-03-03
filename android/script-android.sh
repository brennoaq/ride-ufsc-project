cd "app"

echo "\n-----  Android application -----\n\n"
echo "\n----- change bundleId -----\n\n"
echo "Enter bundleId name: "
read newbundleID

oldBundleID="com.boilerplate"

sed -i "" "s/$oldBundleID/$newbundleID/g" ./build.gradle

#  App name

echo "\n----- change App name  -----\n\n"
echo "Enter AppName: "
read newAppName
oldAppName="BoilerPlateNameReplace"

sed -i "" "s/$oldAppName/$newAppName/g" ./build.gradle