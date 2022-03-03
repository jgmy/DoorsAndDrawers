@echo off
REM Check for java
TITLE Doors and drawers - Looking for java, please wait
if %JAVA%.==. goto :nojava

:recheckjava
REM Java var found.
color 07
TITLE Doors and drawers - Java found
If NOT EXIST "%JAVA%\bin\java.exe" goto :nojava2

REM Java var found and valid. Set path.
path %java%\bin;%PATH%

REM Get appdir
for %%a in (%0) do set APPDIR=%%~pa
if %APPDIR%==. set APPDIR=%CD%

REM About to start java
TITLE Doors and drawers - Press CNTRL-C in this window to exit app
java -Djna.nosys=true -Djava.library.path="%APPDIR%;%APPDIR%/lib" -cp "%APPDIR%;%APPDIR%/lib/doorsanddrawers.jar;%APPDIR%/lib/core.jar;%APPDIR%/lib/jogl-all.jar;%APPDIR%/lib/gluegen-rt.jar;%APPDIR%/lib/jogl-all-natives-linux-i586.jar;%APPDIR%/lib/gluegen-rt-natives-linux-i586.jar" doorsanddrawers "%*"
goto :end

:nojava
REM Java var not found
TITLE Doors and drawers - Java var is not defined.
color 47
ECHO Java var is not defined
WHERE $PATH:java.exe
if errorlevel 1 goto :nojava3

for /F "usebackq delims=" %%A in (`where $path:java.exe`) do if %JAVA%.==. SET JAVA=%%~dpA..
if %JAVA%.==. goto :nojava3

goto :recheckjava

:nojava2
:nojava3
color 47
echo * * * * * * * * * * * * * * * * * * * * * * *
echo * Java.exe not found                        *
echo * please install a Java Runtime (JRE) from  *
echo * java.com or openjdk.java.net              *
echo *                                           *
echo * This program is designed to be run under  *
echo * java 8 build 202, which was the last      *
echo * release of java as free for commercial    *
echo * use on computers                          *
echo * * * * * * * * * * * * * * * * * * * * * * *
pause
:end