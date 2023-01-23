db = connect("mongodb+srv://HelloAtlas:helloatlas@cluster0.fwvzr.mongodb.net/christmasDB?retryWrites=true&w=majority")

printjson(db.activeSchedules.aggregate([
  { $group: { _id: "$scheduleDate", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
]))