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
    Mongo.Db db = Mongo.Db('mongodb://10.0.2.2:27017/fitness');
    _initWorkouts(db).then((value) {
      print('Workouts got');
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

  _initWorkouts(Mongo.Db db) async {
    await db.open();

    print('Connected to database');
    Mongo.DbCollection coll2 = db.collection('exercises');

    var exercisesDb = await coll2.find().toList();
    Mongo.DbCollection coll = db.collection('workouts');

    var workoutsDb = await coll.find().toList();
    for (var i = 0; i < workoutsDb.length; i++) {
      var imageBin = workoutsDb[i]['image'];
      var img = _selectImage(imageBin);

      WorkoutModel workout = new WorkoutModel(
          name: workoutsDb[i]['name'],
          description: workoutsDb[i]['description'].join(),
          imageBin: img);

      exercises.clear();
      _initExercises(exercisesDb, workout, workoutsDb[i]['exercises'])
          .then((value) {
        print('Exercise got');
      });

      var exercisesOfWorkout = new List<ExerciseModel>.from(exercises);
      workout.setExercises(exercisesOfWorkout);
      _workoutsStore.addWorkout(workout);
    }
    await db.close();
  }

  _initExercises(List<Map<String, dynamic>> exercisesDb, WorkoutModel workout,
      List<dynamic> exercisesOfWorkout) async {
    ExerciseModel exercise;
    for (var i = 0; i < exercisesOfWorkout.length; i++) {
      print('exercise of workout $i');
      var found = false;
      for (var j = 0; j < exercisesDb.length; j++) {
        if (exercisesOfWorkout[i][0] == exercisesDb[j]['name']) {
          found = true;
          print('exercise from db matched');
          var imageBin = exercisesDb[j]['image'];
          var img = _selectImage(imageBin);
          var description = exercisesDb[j]['description'];
          if (description is String) {
            description = description;
          } else {
            description = description.join();
          }

          exercise = new ExerciseModel(
              name: exercisesDb[j]['name'],
              description: description,
              image: img,
              video: exercisesDb[j]['video'],
              reps: exercisesOfWorkout[i][1]);
        }
      }
      if (found == false) {
        exercise = new ExerciseModel(
            name: exercisesOfWorkout[i][0],
            description: "",
            image: "",
            video: "",
            reps: exercisesOfWorkout[i][1]);
      }
      exercises.add(exercise);
    }
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
              itemSelectedCallback: (item) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExerciseList(
                          exercises: item.exercises, workout: item)),
                );
              },
            )),
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
              exercises: getExercises(_selectedItem),
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

getExercises(WorkoutModel workout) {
  if (workout != null)
    return workout.exercises;
  else
    return null;
}
