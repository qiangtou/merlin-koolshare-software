del *.tar
del *.gz
set app=ideaServer
7z a %app%.tar %app%/
7z a -tgzip %app%.tar.gz %app%.tar

set app=virtualHere
7z a %app%.tar %app%/
7z a -tgzip %app%.tar.gz %app%.tar

del *.tar

pause