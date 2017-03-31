@ECHO OFF
echo APK Uploader and Installer v1.0
echo created by Heru Prasetia
adb push  "%~1" /sdcard/Download/
adb install -r "%~1"
pause
