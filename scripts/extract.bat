@echo off
setlocal

:: inputs
SET GAME_DIR=%1

:: repo paths
SET SCRIPTS_DIR=%~dp0
SET REPO_ROOT=%SCRIPTS_DIR%..
SET ASSETS_DIR=%REPO_ROOT%\assets
SET DATA_DIR=%REPO_ROOT%\data
SET HEADERS_DIR=%REPO_ROOT%\headers

:: tools
SET JQ=%SCRIPTS_DIR%vendor\jq\jq-win64.exe
SET SIGCHECK=%SCRIPTS_DIR%vendor\sigcheck\sigcheck64.exe
SET UMODEL=%SCRIPTS_DIR%vendor\umodel\umodel.exe

:: metadata
%SIGCHECK% %GAME_DIR%\FactoryGame.exe | findstr /C:"Prod version:" > .temp-version
set /p VERSION_LINE= < .temp-version
set VERSION=%VERSION_LINE:*CL-=%
del .temp-version

if %errorlevel% neq 0 exit /b %errorlevel%

:: assets
rmdir /Q /S %ASSETS_DIR%
%UMODEL% -game="ue4.22" -path=%GAME_DIR% -out=%ASSETS_DIR% -png -export */UI/*

if %errorlevel% neq 0 exit /b %errorlevel%

:: data
rmdir /Q /S %DATA_DIR%
mkdir %DATA_DIR%
for /R %GAME_DIR%\CommunityResources\Docs %%f in (*.json) do (
    type "%%f" | %JQ% . > %DATA_DIR%\%%~nxf
)

if %errorlevel% neq 0 exit /b %errorlevel%

:: headers
rmdir /Q /S %HEADERS_DIR%
mkdir %HEADERS_DIR%
tar -x -f %GAME_DIR%\CommunityResources\Headers.zip -C %HEADERS_DIR%

if %errorlevel% neq 0 exit /b %errorlevel%

:: finish up
git add .
git commit -m "CL %VERSION%"
git tag %VERSION%
git push
git push --tags
