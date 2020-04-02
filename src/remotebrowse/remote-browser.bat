set host=192.168.56.101
set port=1234
set logfile="C:\tmp\browse.log"

echo starting %*> %logfile%
rem  "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" -osint -url "%1">> %logfile%
echo %1 | ncat %host% %port%>> %logfile%
rem timeout /t 20
echo finished %*>> %logfile%
