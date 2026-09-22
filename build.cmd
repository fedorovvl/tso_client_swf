@echo off
setlocal EnableDelayedExpansion
set "ROOT=%~dp0"
set "ROOT=!ROOT:~0,-1!"
if not defined JAVA set "JAVA=java"
set "MODE="
set "KEEP="
if /I "%~1"=="-DebugBuild" set "MODE=-compiler.debug=true"
if /I "%~1"=="-MinimalBuild" set "MODE=-compiler.debug=false -compiler.optimize=true -compiler.compress=true"
if /I "%~1"=="-KeepGeneratedCode" set "KEEP=-compiler.keep-generated-actionscript=true"
if /I "%~2"=="-KeepGeneratedCode" set "KEEP=-compiler.keep-generated-actionscript=true"
where java >nul 2>&1
if errorlevel 1 ( echo Java not found in PATH. & exit /b 1 )

rem ---- theme (mxmlc 3.6 needs localFonts.ser in CWD) ----
pushd "%ROOT%\sdk\3.6.0\frameworks"
"%JAVA%" -jar ..\lib\mxmlc.jar -load-config=..\..\..\theme-config.xml ..\..\..\assets\theme\swmmoTheme.css -output ..\..\..\assets\theme\swmmo-theme.swf
if errorlevel 1 ( popd & echo Theme build failed. & exit /b 1 )
popd
echo Build succeeded: assets\theme\swmmo-theme.swf

rem ---- frames config (force-link string-loaded classes) ----
set "CFG=%ROOT%\linker-config.xml"
> "%CFG%" echo ^<flex-config^>
>>"%CFG%" echo   ^<frames^>^<frame^>^<label^>main^</label^>
pushd "%ROOT%\src"
for /R . %%F in (*.as *.mxml) do (
    set "RF=%%F"
    set "RF=!RF:%ROOT%\src\=!"
    set "RF=!RF:.\=!"
    if "!RF:~0,4!"=="src\" set "RF=!RF:~4!"
    if "!RF:generated\=!"=="!RF!" (
        if not "!RF!"=="_SWMMO_mx_managers_SystemManager.as" (
            set "CN=!RF:\=.!"
            if /I "!CN:~-5!"==".mxml" ( set "CN=!CN:~0,-5!" ) else ( set "CN=!CN:~0,-3!" )
            echo     ^<classname^>!CN!^</classname^>>>"%CFG%"
        )
    )
)
popd
>>"%CFG%" echo   ^</frame^>^</frames^>
>>"%CFG%" echo ^</flex-config^>

rem ---- client ----
pushd "%ROOT%"
"%JAVA%" -Duser.language=en -Duser.country=US -Xmx2g -Dfile.encoding=UTF-8 -Dflexlib=sdk\4.16.1\frameworks -jar sdk\4.16.1\lib\mxmlc.jar -load-config=compiler-config.xml -load-config+=linker-config.xml %MODE% %KEEP% -output=client.swf src\_SWMMO_mx_managers_SystemManager.as > compile.log 2>&1
if errorlevel 1 ( popd & echo Compilation failed. See compile.log. & exit /b 1 )
popd
echo Build succeeded: client.swf
