echo off

mongosh "mongodb+srv://cluster0.fwvzr.mongodb.net/myFirstDatabase" --username HelloAtlas --password helloatlas --file ../mongoScripts/mongoCancellationsPerDay.js

PAUSE