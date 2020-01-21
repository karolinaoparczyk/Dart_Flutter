import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipm1920_p2/models/exercisemodel.dart';
import 'package:ipm1920_p2/models/workoutmodel.dart';
import 'package:ipm1920_p2/widgets/exercise.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class ExerciseList extends StatelessWidget {
  ExerciseList({@required this.workout, @required this.exercises});
  WorkoutModel workout;
  List<ExerciseModel> exercises;
  final ScrollController _rrectController2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getWorkoutName(workout)),
      ),
      body: Container(
        child: Observer(
          builder: (_) => checkIfExists(exercises)
              ? DraggableScrollbar.semicircle(
                  controller: _rrectController2,
                  backgroundColor: Colors.grey,
                  heightScrollThumb: 50,
                  child: ListView(
                    controller: _rrectController2,
                    children: exercises.map((item) {
                      return _initExercises(item);
                    }).toList(),
                  ),
                )
              : new ListTile(
                  title: Text(
                    "Select a workout to see details",
                    style: new TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
  }
}

checkIfExists(List<ExerciseModel> exercises) {
  if (exercises != null) {
    if (exercises.isNotEmpty)
      return true;
    else
      return false;
  } else
    return false;
}

getWorkoutName(WorkoutModel workout) {
  if (workout != null)
    return workout.name;
  else
    return "";
}

Widget _initExercises(ExerciseModel exercise) {
  if (exercise != null)
    return new ExerciseWidget(exerciseItem: exercise);
  else
    return new Text("No workout selected");
}
