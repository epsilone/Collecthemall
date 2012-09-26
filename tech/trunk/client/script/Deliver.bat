@echo off
SET PROJECT_DIR=%1
SET OUTPUT_DIR=%2

XCOPY %PROJECT_DIR%\data %OUTPUT_DIR%\data /Y /S /E /I>nul
XCOPY %PROJECT_DIR%\asset\precompiled %OUTPUT_DIR%\asset /Y /S /E /I>nul