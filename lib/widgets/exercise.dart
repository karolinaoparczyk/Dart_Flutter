import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipm1920_p2/models/exercisemodel.dart';

Widget _getImage(String image) {
  if (image == "") {
    return Image.asset('assets/images/noimage.png');
  } else {
    return Image.memory(base64.decode(image));
  }
}

class ExerciseWidget extends StatelessWidget {
  final ExerciseModel exerciseItem;

  const ExerciseWidget({Key key, @required this.exerciseItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    new Center(
                      child: new Text(
                        exerciseItem.name,
                        style: new TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    new Center(
                        child: new Text(exerciseItem.reps,
                            style: new TextStyle(
                                color: Colors.green[800], fontSize: 35.0))),
                    new Center(
                      child: _getImage(exerciseItem.image),
                    ),
                    new Center(
                        child: new Text(
                      exerciseItem.description,
                      style: new TextStyle(fontSize: 23.0),
                      textAlign: TextAlign.justify,
                    ))
                  ]))
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}

getTimer(String duration){
  var intDuration;
  var splited = duration.split(",");
  if (splited.contains("rep")){
    intDuration = int.parse(splited[0]);
  }
  else{
    var strDuration = duration.substring(0,2);
    intDuration = int.parse(strDuration);
  }
  return intDuration;
  /*Timer(Duration(seconds: intDuration), () {
    print("Yeah, this line is printed after $intDuration second");
  });*/
}
