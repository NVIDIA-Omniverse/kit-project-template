@echo off
setlocal
set arg1=%1
set SCRIPT_DIR=%~dp0
shift
call "%SCRIPT_DIR%\..\kit\kit.exe"  --enable omni.kit.test --/exts/omni.kit.test/testExts/0='%arg1%' --/app/enableStdoutOutput=0 --portable-root "%SCRIPT_DIR%\.." %*
