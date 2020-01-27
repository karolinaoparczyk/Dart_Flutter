import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipm1920_p2/models/exercisemodel.dart';
import 'package:ipm1920_p2/widgets/timer.dart';

Widget _getImage(String image) {
  if (image == "") {
    return Image.asset('assets/images/noimage.png', );
  } else {
    return Image.memory(base64.decode(image), width: 200, height: 350,);
  }
}

class PerformExerciseWidget extends StatelessWidget {
  final ExerciseModel currentExercise;
  final List<ExerciseModel> exercises;

  const PerformExerciseWidget(
      {Key key, @required this.currentExercise, @required this.exercises})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Center(
                      child: Text(
                    currentExercise.name,
                    style: new TextStyle(fontSize: 30),
                        textAlign: TextAlign.justify,
                  )),
                  new Center(
                      child: getTimer(currentExercise, exercises, context)),
                  new Center(
                    child: currentExercise.description == ""
                        ? _getImage(currentExercise.image)
                        : Text(currentExercise.description),
                  )
                ]))),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}

getTimer(ExerciseModel exercise, List<ExerciseModel> exercises,
    BuildContext context) {
  var id;
  for (var i = 0; i < exercises.length; i++) {
    if (exercises[i].name == exercise.name) {
      id = i;
      break;
    } else
      id = 0;
  }
  return new CountDownTimer(
    secondsRemaining: getDuration(exercise.reps),
    whenTimeExpires: () {
      if (id + 1 < exercises.length) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => new Scaffold(
                appBar: AppBar(
                  title: Text('Perform workout'),
                ),
                body: Center(
                    child: PerformExerciseWidget(
                        currentExercise: exercises[id + 1],
                        exercises: exercises)))));
      }
    },
    countDownTimerStyle: TextStyle(
      color: Colors.green[800],
      fontSize: 57.0,
    ),
  );
}

getDuration(String duration) {
  var intDuration;
  var splited = duration.split(",");
  if (splited.contains("rep")) {
    intDuration = int.parse(splited[0]) * 3;
  } else if (splited.contains("'")) {
    intDuration = int.parse(splited[0]) * 60;
  } else {
    var strDuration = duration.substring(0, 2);
    intDuration = int.parse(strDuration);
  }
  return intDuration;
}
