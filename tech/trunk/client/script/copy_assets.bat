@echo off
ECHO Copying precompiled assets to their final destination.

XCOPY %1 %2 /Y /S /E /I>nul