@echo off

set target=%1

@REM echo try build the %target%


@REM for /f "tokens=* delims=" %%# in ('jq -r ".name" %target%/info.json') do @(set modname=%%#)
@REM for /f "tokens=* delims=" %%# in ('jq -r ".version" %target%/info.json') do @(set version=%%#)

@REM echo %modname% %version%

@REM echo packing %modname% into %modname%_%version%.zip

@REM tar.exe -a -c -f  %modname%_%version%.zip %target%

goft.exe -b -d %target%