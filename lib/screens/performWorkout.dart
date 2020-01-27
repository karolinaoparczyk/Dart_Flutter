import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipm1920_p2/models/exercisemodel.dart';
import 'package:ipm1920_p2/widgets/performExercise.dart';

class PerformWorkout extends StatefulWidget {
  final List<ExerciseModel> exercises;
  const PerformWorkout(this.exercises);

  @override
  PerformWorkoutState createState() => PerformWorkoutState();
}

class PerformWorkoutState extends State<PerformWorkout> {

  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Perform workout'),
        ),
        body: Center(
            child: PerformExerciseWidget(currentExercise: widget.exercises[0],
                exercises: widget.exercises)));
  }
}
