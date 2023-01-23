echo off

mongo < mongoScripts/mongoPrepareToUpdate.txt

for /r %%f in (.\export\*) do (
echo exporting %%~nxf
mongoimport --db=christmasDB --collection=schedules --file=export\%%~nxf
)

mongo < mongoScripts/mongoPipeLine.txt

PAUSE

