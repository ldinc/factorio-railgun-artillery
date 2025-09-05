@REM @REM @echo off

@REM set target=%1

@REM if "%~1" == "" (
@REM   echo "try build all"

@REM ) else (

@REM   echo try build the %target%

@REM   set modname='none'
@REM   set version='none'

@REM   echo %modname% %version%

@REM   for /f "tokens=* delims=" %%# in ('jq -r ".name" %target%/info.json') do @(set modname=%%#)
@REM   for /f "tokens=* delims=" %%# in ('jq -r ".version" %target%/info.json') do @(set version=%%#)

@REM   echo packing %modname% into %modname%_%version%.zip

@REM   tar.exe -a -c -f  %modname%_%version%.zip %target%
@REM )

goft.exe -b