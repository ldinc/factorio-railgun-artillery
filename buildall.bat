@REM @echo off

set target=%1

if "%~1" == "" (
  echo "try build all"

) else (

  echo try build the %target%

  set modname='none'
  set version='none'

  echo %modname% %version%

  for /f "tokens=* delims=" %%# in ('jq -r ".name" %target%/info.json') do @(set modname=%%#)
  for /f "tokens=* delims=" %%# in ('jq -r ".version" %target%/info.json') do @(set version=%%#)

  echo packing %modname% into %modname%_%version%.zip

  tar.exe -a -c -f  %modname%_%version%.zip %target%
)
