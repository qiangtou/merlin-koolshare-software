@echo off

del *.tar
del *.gz

set packageDir=package

if exist %packageDir% (
	rd %packageDir% /s/q
) else (
	md %packageDir%
)

call :myPackage ideaServer
call :myPackage virtualHere
del *.tar
dir %packageDir%
pause
exit /b 0

:myPackage
	set workDir=%~dp0
	set app=%1
	echo app is : [%app%]
	xcopy  %app% %packageDir%\%app%\ /se
	xcopy  base %packageDir%\%app%\ /se
	cd %workDir%\%packageDir%
	%workDir%\7z a %app%.tar %app%
	%workDir%\7z a -tgzip %app%.tar.gz %app%.tar
	cd %workDir%
goto:eof

