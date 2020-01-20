import 'dart:convert';

import 'package:ipm1920_p2/models/workoutmodel.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;

main () async {
  Mongo.Db db = Mongo.Db('mongodb://10.0.2.2:27017/fitness');
  await db.open();

  print('Connected to database');
  var workouts;

  Mongo.DbCollection coll = db.collection('workouts');

  var workoutsDb = await coll.find().toList();
  for (var i=0; i<workoutsDb.length; i++) {
    var imageBin = workoutsDb[i]['image'];
    var img = _selectImage(imageBin);
    WorkoutModel workout = new WorkoutModel(name: workoutsDb[i]['name'],
        description: workoutsDb[i]['description'].join(), imageBin: img);
    workouts.add(workout);
  }
  await db.close();

  return workouts;
}

String _selectImage(image){
  if (image.runtimeType!=String || image==null){
    return image= utf8.decode(image.byteList);
  }else {
    return "";
  }
}