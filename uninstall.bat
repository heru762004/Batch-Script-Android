@ECHO OFF
echo APK Uninstaller v1.0
echo created by Heru Prasetia
ECHO "%~1"
set AAPT=%ANDROID_HOME%\build-tools\21.1.1\aapt
FOR %%i IN ("%~1") DO (
SET filedrive=%%~di
SET filepath=%%~pi
SET filename=%%~ni
SET fileextension=%%~xi
)
SET fPath=%filedrive%%filepath%
ECHO "%fPath%"
cd "%fPath%"
SET P=%filename%%fileextension%
echo %P%
set X=%AAPT% d badging %P%
for /f "delims=' tokens=2,4" %%a in ('%X%') do (
    echo Package name is %%a
    echo Version code is %%b
	set Y=%%a
	goto :break
)
:break
echo %Y%
adb shell am start -a android.intent.action.DELETE -d package:%Y%
pause
