@ECHO OFF
echo APK Uninstaller, Uploader and Installer v1.0
echo created by Heru Prasetia
CALL %0\..\uninstaller.bat "%~1"
adb push  "%~1" /sdcard/Download/
adb install -r "%~1"
pause
