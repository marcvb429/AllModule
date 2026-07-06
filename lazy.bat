@echo off
set /p CommitName=Commit Name: 

pause

@echo on
git add .
git commit -m "%CommitName%"
git push

@echo off
pause