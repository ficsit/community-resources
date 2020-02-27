@echo off

git fetch origin
git checkout experimental
git pull

%~dp0\extract.bat "C:\Program Files\Epic Games\SatisfactoryExperimental"
