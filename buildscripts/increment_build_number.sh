#!/bin/bash

buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${INFOPLIST_FILE}")
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${INFOPLIST_FILE}"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$SRCROOT/NotificationService/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$SRCROOT/TodayExtension/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$SRCROOT/WidgetExtension/Info.plist"