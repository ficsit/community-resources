@echo off

git fetch origin
git checkout master
git pull

%~dp0\extract.bat "C:\Program Files\Epic Games\SatisfactoryEarlyAccess"
