@echo off

set branch=stable

set target=%1


if %target%==unstable (
  set target=%2
  set branch=unstable
)

echo target %target%
echo release %branch%

@REM call build.bat %target%

set mp=.factorio.%branch%


for /f "tokens=* delims=" %%# in ('jq -r %mp% build.config.json') do @(set target=%%#)

@REM echo copy to %target%
@REM move %modname%_%version%.zip %target%mods\

goft.exe -b -o %target%mods\

@REM @REM start steam://rungameid/427520
call %target%bin\x64\factorio.exe