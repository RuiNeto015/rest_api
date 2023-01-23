# Christmas REST API
REST API to help Santa Claus managing his visits to the factory.

### Run the local server
To **start the local server** run the following script on the project folder dir.
```sh
basexhttp.bat
```

### HTTP Requests
| Method | EndPoint |Description| Query Params | Headers |
| ------ | -------- |---------- | ------------ | ------- |
| GET | http://localhost:8984/getSchedules | Returns all the schedules. | n.a.| default |
| GET | http://localhost:8984/export | Exports all the schedules to ./export as .json files. | n.a.| default |
| GET | http://localhost:8984/getAvailableSlotsInTimeInterval | Returns all the free slots between a time interval. | startDate=YYYY-MM-dd and finishDate=YYYY-MM-dd| default |
| POST | http://localhost:8984/add | Adds an Schedule if valid and possible attending to the preference dates. | n.a.| Content-Type = application/xml |
| DEL | http://localhost:8984/cancelSchedule | Cancels a schedule. | id=SCHEDULE_ID_# | default |

### Importing to mongo
**Before excuting the following process** be aware that all the .json files inside the ./export folder will be imported to mongo, wich  implies the method "http://localhost:8984/export" being called firstly.

##### Locally
To **import to Mongo** run the following script on the project folder dir.
```sh
updateToMongo.bat
```

##### Atlas
To **import to Atlas** run the following script on the project folder dir.
```sh
updateToAtlas.bat
```
Note: The previous script is only runnable if your IP address is registered on the Atlas Network Acess section of the project.

#### Mongo Charts
To acess the ChristmasAPI data charts click [here](https://charts.mongodb.com/charts-project-0-entuy/public/dashboards/61d0f46b-2c98-4d5a-8908-1d126b4d8c05).

### Development Team
- Simão Santos simaosantos01@gmail.com
- Rui Neto ruineto015@gmail.com
