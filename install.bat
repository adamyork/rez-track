@echo off
echo installing RezTrack ...
set WOW_HOME=C:\Users\Public\World of Warcraft
set CURR_DIR=%CD%
cd %WOW_HOME%\Interface\AddOns\
if EXIST Reztrack/ (
	RMDIR /s /q Reztrack
)
MKDIR RezTrack\libs
cd %CURR_DIR%
xcopy .\src "%WOW_HOME%\Interface\AddOns\Reztrack" /S
xcopy .\lib "%WOW_HOME%\Interface\AddOns\Reztrack\libs" /S
echo installation complete.