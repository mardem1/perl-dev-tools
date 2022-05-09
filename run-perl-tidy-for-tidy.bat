
rem # run perl tidy on the perl-tidy script

cls

cd %~dp0

cmd.exe /c perltidy .\run-10-perl-tidy.pl
echo %ErrorLevel%

del /S /Q .\run-10-perl-tidy.pl.bak
echo %ErrorLevel%

exit /b 0
