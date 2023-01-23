echo off

mongosh "mongodb+srv://cluster0.fwvzr.mongodb.net/myFirstDatabase" --username HelloAtlas --password helloatlas --file mongoScripts/mongoPrepareToUpdate.js

for /r %%f in (.\export\*) do (
echo exporting %%~nxf
mongoimport --uri "mongodb+srv://HelloAtlas:helloatlas@cluster0.fwvzr.mongodb.net/christmasDB?retryWrites=true&w=majority" --collection schedules --file export\%%~nxf
)

mongosh "mongodb+srv://cluster0.fwvzr.mongodb.net/myFirstDatabase" --username HelloAtlas --password helloatlas --file mongoScripts/mongoPipeLine.js

PAUSE