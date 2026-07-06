set /p CommitName=Commit Name

pause

git add .
git commit -m "%CommitName%"
git push

pause