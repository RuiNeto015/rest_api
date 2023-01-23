db = connect("mongodb+srv://HelloAtlas:helloatlas@cluster0.fwvzr.mongodb.net/christmasDB?retryWrites=true&w=majority")

db.activeSchedules.drop()
db.canceledSchedules.drop()
db.members.drop()