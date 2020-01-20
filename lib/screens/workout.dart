import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ipm1920_p2/models/exercisemodel.dart';
import 'package:ipm1920_p2/widgets/exerciseList.dart';
import 'package:ipm1920_p2/widgets/workoutList.dart';
import '../models/workouts.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import 'package:ipm1920_p2/models/workoutmodel.dart';

class Workout extends StatefulWidget {
  @override
  WorkoutState createState() {
    return new WorkoutState();
  }
}

class WorkoutState extends State<Workout> {
  Workouts _workoutsStore = new Workouts();
  List<ExerciseModel> exercises = new List<ExerciseModel>();
  WorkoutModel _selectedItem;

  @override
  void initState() {
    _initWorkouts().then((value) {
      print('Workouts got');
    });
    _initExercises().then((value) {
      print('Exercises got');
    });
    super.initState();
  }

  String _selectImage(image) {
    if (image.runtimeType != String || image == null) {
      return image = utf8.decode(image.byteList);
    } else {
      return "";
    }
  }

  _initWorkouts() async {
    Mongo.Db db = Mongo.Db('mongodb://10.0.2.2:27017/fitness');
    await db.open();

    print('Connected to database');

    Mongo.DbCollection coll = db.collection('workouts');

    var workoutsDb = await coll.find().toList();
    for (var i = 0; i < workoutsDb.length; i++) {
      var imageBin = workoutsDb[i]['image'];
      var img = _selectImage(imageBin);
      WorkoutModel workout = new WorkoutModel(
          name: workoutsDb[i]['name'],
          description: workoutsDb[i]['description'].join(),
          imageBin: img);
      _workoutsStore.addWorkout(workout);
    }
    await db.close();
  }

  _initExercises() async {
    Mongo.Db db = Mongo.Db('mongodb://10.0.2.2:27017/fitness');
    await db.open();

    print('Connected to database');

    Mongo.DbCollection coll = db.collection('exercises');

    var exercisesDb = await coll.find().toList();
    for (var i = 0; i < exercisesDb.length; i++) {
      var imageBin = exercisesDb[i]['image'];
      var img = _selectImage(imageBin);
      var description = exercisesDb[i]['description'];
      if (description is String) {
        description = description;
      } else {
        description = description.join();
      }
      ExerciseModel exercise = new ExerciseModel(
          name: exercisesDb[i]['name'],
          description: description,
          image: img,
          video: exercisesDb[i]['video']);
      exercises.add(exercise);
    }
    await db.close();
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: WorkoutList(
              workouts: _workoutsStore.workouts,
              exercises: exercises,
              itemSelectedCallback: (item) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExerciseList(
                            exercises: exercises,
                            workout: item,
                          )),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 5,
          child: Material(
            elevation: 50.0,
            child: WorkoutList(
              workouts: _workoutsStore.workouts,
              exercises: exercises,
              itemSelectedCallback: (item) {
                setState(() {
                  _selectedItem = item;
                });
              },
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Material(
            elevation: 4.0,
            child: ExerciseList(
              exercises: exercises,
              workout: _selectedItem,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;

    if (useMobileLayout) {
      return _buildMobileLayout();
    }

    return _buildTabletLayout();
  }
}
