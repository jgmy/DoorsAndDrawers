for %%a in (%0) do set APPDIR=%%~pa
if "%APPDIR%"=="" set APPDIR=%CD%
java -Djna.nosys=true -Djava.library.path="%APPDIR%;%APPDIR%/lib" -cp "%APPDIR%;%APPDIR%/lib/doorsanddrawers.jar;%APPDIR%/lib/core.jar;%APPDIR%/lib/jogl-all.jar;%APPDIR%/lib/gluegen-rt.jar;%APPDIR%/lib/jogl-all-natives-linux-i586.jar;%APPDIR%/lib/gluegen-rt-natives-linux-i586.jar" doorsanddrawers "%*"
