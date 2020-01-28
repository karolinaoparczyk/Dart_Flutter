import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipm1920_p2/models/exercisemodel.dart';
import 'package:ipm1920_p2/screens/workout.dart';

Widget _getImage(String image) {
  if (image == "") {
    return Image.asset(
      'assets/images/noimage.png',
    );
  } else {
    return Image.memory(
      base64.decode(image),
      width: 300,
      height: 450,
    );
  }
}

class PerformExercise extends StatefulWidget {
  final ExerciseModel currentExercise;
  final List<ExerciseModel> exercises;
  const PerformExercise({this.currentExercise, this.exercises});

  @override
  PerformExerciseState createState() => PerformExerciseState();
}

class PerformExerciseState extends State<PerformExercise>
    with TickerProviderStateMixin {
  AnimationController controller;
  BuildContext _mycontext;
  bool isAnimated = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: getDuration(widget.currentExercise.reps)),
    );
    countdown();

    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) goToNext();
    });
  }

  countdown() {
    if (controller.isAnimating)
      controller.stop();
    else {
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    }
  }

  goToNext() {
    var id;
    for (var i = 0; i < widget.exercises.length; i++) {
      if (widget.exercises[i].name == widget.currentExercise.name) {
        id = i;
        break;
      } else
        id = 0;
    }
    if (id + 1 < widget.exercises.length) {
      Navigator.of(_mycontext).push(MaterialPageRoute(
          builder: (_mycontext) => new Scaffold(
              appBar: AppBar(
                title: Text('Perform workout'),
              ),
              body: Center(
                  child: PerformExercise(
                      currentExercise: widget.exercises[id + 1],
                      exercises: widget.exercises)))));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Workout()));
    }
  }

  @override
  Widget build(BuildContext context) {
    _mycontext = context;
    return Scaffold(
        body: Container(
            child: Observer(
                builder: (_) => ListView(children: <Widget>[
                      Container(
                          child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Center(
                                        child: Text(
                                      widget.currentExercise.name,
                                      style: new TextStyle(fontSize: 30),
                                      textAlign: TextAlign.justify,
                                    )),
                                    AnimatedBuilder(
                                      animation: controller,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return Text(
                                            "${(controller.duration * controller.value).inMinutes}:${((controller.duration * controller.value).inSeconds % 60)}"
                                                .padLeft(2, '0'),
                                            style: TextStyle(fontSize: 40));
                                      },
                                    ),
                                    new Center(
                                      child: widget.currentExercise
                                                  .description ==
                                              ""
                                          ? _getImage(
                                              widget.currentExercise.image)
                                          : Text(
                                              widget
                                                  .currentExercise.description,
                                              style: TextStyle(fontSize: 23),
                                              textAlign: TextAlign.justify,
                                            ),
                                    ),
                                    AnimatedBuilder(
                                        animation: controller,
                                        builder: (context, child) {
                                          return new Center(
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center
                                                  ,children: <Widget>[
                                            FloatingActionButton.extended(
                                                heroTag: "btn1",
                                                onPressed: () {
                                                  var temp =
                                                      controller.isAnimating;
                                                  if (controller.isAnimating)
                                                    controller.stop();
                                                  else {
                                                    controller.reverse(
                                                        from: controller
                                                                    .value ==
                                                                0.0
                                                            ? 1.0
                                                            : controller.value);
                                                  }
                                                  setState(() {
                                                    isAnimated = temp;
                                                  });
                                                },
                                                icon: Icon(!isAnimated
                                                    ? Icons.pause
                                                    : Icons.play_arrow),
                                                label: Text(!isAnimated
                                                    ? "Pause"
                                                    : "Play", style:
                                                TextStyle(fontSize: 18.0))),
                                            FloatingActionButton.extended(
                                              heroTag: "btn2",
                                              onPressed: () {
                                                goToNext();
                                              },
                                              label: Text(
                                                "Skip",
                                                style:
                                                    TextStyle(fontSize: 18.0),
                                              ),
                                              icon: Icon(Icons.skip_next),
                                              highlightElevation: 40.0,
                                            )
                                          ]));
                                        }),
                                  ])))
                    ]))));
  }
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
