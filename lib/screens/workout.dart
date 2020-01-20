import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipm1920_p2/widgets/workout.dart';
import '../models/workouts.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import 'package:ipm1920_p2/models/workoutmodel.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class Workout extends StatefulWidget {
  @override
  WorkoutState createState() {
    return new WorkoutState();
  }
}

class WorkoutState extends State<Workout> {
  Workouts _workoutsStore = new Workouts();
  ScrollController _rrectController = ScrollController();

  @override
  void initState(){
    _initWorkouts().then((value){
      print('Async done');
    });
    super.initState();
  }

  String _selectImage(image){
    if (image.runtimeType!=String || image==null){
      return image= utf8.decode(image.byteList);
    }else {
      return "";
    }
  }

  _initWorkouts() async {
    Mongo.Db db = Mongo.Db('mongodb://10.0.2.2:27017/fitness');
    await db.open();

    print('Connected to database');

    Mongo.DbCollection coll = db.collection('workouts');

    var workoutsDb = await coll.find().toList();
    for (var i=0; i<workoutsDb.length; i++) {
      var imageBin = workoutsDb[i]['image'];
      var img = _selectImage(imageBin);
      WorkoutModel workout = new WorkoutModel(name: workoutsDb[i]['name'],
          description: workoutsDb[i]['description'].join(), imageBin: img);
      _workoutsStore.addWorkout(workout);
    }
    await db.close();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 24.0),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.accessibility_new),
                  SizedBox(width: 10.0),
                  Text(
                    "Workouts",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Observer(
                  builder: (_) => _workoutsStore.workouts.isNotEmpty
                      ? DraggableScrollbar.rrect(
                      controller: _rrectController,
                      backgroundColor: Colors.green,
                         heightScrollThumb: 100,
                         child: ListView(
                           controller: _rrectController,
                           children:
                             _workoutsStore.workouts.reversed.map((workoutItem) {
                            return WorkoutWidget(
                             workoutItem: workoutItem,
                            );
                            }).toList(),
                         )
                      )
                      : new Center(
                         child: new CircularProgressIndicator(),

              ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}