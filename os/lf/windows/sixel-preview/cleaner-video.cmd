@echo off
setlocal DisableDelayedExpansion
"%~dp0lf-video.exe" stop "%id%"
exit /b 0
