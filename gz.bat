@echo off

del *.tar
del *.gz

if exist package (
	rd package /s/q
) else (
	md package
)

call :myPackage ideaServer
call :myPackage virtualHere
del *.tar
dir package
pause
exit /b 0

:myPackage
	set app=%1
	echo app is : [%app%]
	7z a %app%.tar %app%/
	7z a -tgzip package/%app%.tar.gz %app%.tar
goto:eof

