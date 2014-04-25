if [ ! -z "$INFO_PLIST" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $TRAVIS_BUILD_NUMBER" "$INFO_PLIST"
  echo "Set CFBundleVersion to $TRAVIS_BUILD_NUMBER"
fi