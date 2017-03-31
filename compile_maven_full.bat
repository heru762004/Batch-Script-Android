@ECHO OFF
echo Maven Compiler v2.0
echo created by Heru Prasetia
setlocal EnableDelayedExpansion
SET mypath=%~dp0
SET apkversion=1.0.0
cd %mypath:~0,-1%
IF NOT EXIST "%mypath:~0,-1%\apk" (
	mkdir apk
)
del apk\*.apk /s
SET /A status = 0
SET /A flag=0
SET n=0
FOR /F "delims=" %%S IN (pom.xml) do (
	SET abc=%%S
	SET abc=!abc: =!
	SET abc=!abc:	=!
	
	IF !status! == 1 (	
		IF "!abc:~0,3!" == "<id"  (
			SET abc=!abc:id=!
			SET abc=!abc:~2,-3!
			SET vector[!n!]=!abc!
			set /A n+=1
			REM echo !abc!
		)
	)
	
	REM echo !abc:~0,3! !flag!
	IF "!abc:~0,3!" == "<--" (
		SET flag=1
	)
	IF "!abc:~-3!" == "-->" (
		SET flag=0
	)
	IF !flag! == 0 (
		IF "!abc!" == "<profile>" (
			REM echo %%S
			SET /A status = 1
		) ELSE (
			SET /A status = 0
		)
	)
	REM echo !status!
)
set /A p=n-1
IF !p! gtr -1 (
	REM echo "have profile"
	for /L %%i in (0,1,!p!) do (
		echo !vector[%%i]!
		REM pause
		CALL mvn clean install -P!vector[%%i]! -Dandroid.sdk.path="%ANDROID_HOME%" -Dsign.storepass=<<pass>> -Dsign.keypass=<<keypass>> -Dsign.keystore="%mypath:~0,-1%\<<keystore>>.keystore" -Dsign.alias=<<alias>> -DapkType=!vector[%%i]! -Dapk.version=!apkversion!
		
		REM read apk
		for /d %%D in (*) do (
			IF EXIST %%~fD\target (
				cd %%~fD\target
				for /r . %%g in (*aligned.apk) do (
					SET tmp=%%g
					IF "!tmp!" NEQ "!tmp:target=!" (
						SET source=%%g
						REM goto :BREAK
					)
				)
				REM if exist !source! goto :BREAK
				cd ..
				cd ..
			)
		)
		echo !source!
		copy "!source!" "%mypath:~0,-1%/apk/"
	)
) ELSE (
	REM echo "does not have profile"
	REM pause
	CALL mvn clean install -Dandroid.sdk.path="%ANDROID_HOME%" -Dsign.storepass=<<pass>> -Dsign.keypass=<<keypass>> -Dsign.keystore="%mypath:~0,-1%\<<keystore>>.keystore" -Dsign.alias=<<alias>> -DapkType=!vector[%%i]! -Dapk.version=!apkversion!
	
	REM read apk
	for /d %%D in (*) do (
		IF EXIST %%~fD\target (
			cd %%~fD\target
			for /r . %%g in (*aligned.apk) do (
				SET tmp=%%g
				IF "!tmp!" NEQ "!tmp:target=!" (
					SET source=%%g
					REM goto :BREAK
				)
			)
			REM if exist !source! goto :BREAK
			cd ..
			cd ..
		)
	)
		echo !source!
		copy "!source!" "%mypath:~0,-1%/apk/"
)


cd "%mypath:~0,-1%\apk"
set /A p=n-1
IF !p! gtr -1 (
	IF !n! == 1 (
		for /r . %%g in (*aligned.apk) do (
			SET tmp=%%g
			echo !tmp!
			cd "%mypath:~0,-1%"
			CALL combo_install.bat "!tmp!"
		)
	) ELSE (
		echo Which APK would you like to install?
		for /L %%i in (0,1,!p!) do (
			echo %%i.!vector[%%i]!
		)
		SET /p a=[0/1/..n]?: 
		for /L %%i in (0,1,!p!) do (
			IF %%i == !a! (
				SET abc=!vector[%%i]!
			)
		)
		
		for  /F "delims=" %%g in ('dir * /s/b ^| findstr \-!abc!\-[0-9]') do (
			echo %%g
			cd "%mypath:~0,-1%"
			CALL combo_install.bat "%%g"
		)
	)
) ELSE (
	for /r . %%g in (*aligned.apk) do (
		SET tmp=%%g
		echo !tmp!
		cd "%mypath:~0,-1%"
		CALL combo_install.bat "!tmp!"
	)
)

REM echo !source!

pause
