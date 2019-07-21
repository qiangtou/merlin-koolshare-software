::@echo off
set workDir=%~dp0
set packageDir=%workDir%package

if exist %packageDir% (
	rd %packageDir% /s/q
) else (
	md %packageDir%
)

for /d %%i in (plugins/*) do (call :myPackage %%i)



pause
exit /b 0
:myPackage
	set app=%1
	echo app is : [%app%]
	
	xcopy  %workDir%\plugins\%app% %packageDir%\%app%\ /se
	xcopy  %workDir%\base %packageDir%\%app%\ /se
	echo uninstall %app%>>%packageDir%\%app%\uninstall.sh
	
	cd %packageDir%
	%workDir%7z a %app%.tar %app%
	%workDir%7z a %app%.tar %workDir%\%app%	
	%workDir%7z a -tgzip %app%.tar.gz %app%.tar
	del %app%.tar
	
	cd %workDir%
goto:eof

