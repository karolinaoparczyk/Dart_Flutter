import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/workoutmodel.dart';
import 'package:path_provider/path_provider.dart';

getPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Widget _getImage(String image) {
  if (image == "") {
    return Image.asset('assets/images/noimage.png');
  } else {
    return Image.memory(base64.decode(image));
  }
}

class WorkoutWidget extends StatelessWidget {
  final WorkoutModel workoutItem;

  const WorkoutWidget({Key key, @required this.workoutItem}) : super(key: key);

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
                        workoutItem.name,
                        style: new TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    new Center(
                      child: _getImage(workoutItem.imageBin),
                    ),
                    new Center(
                        child: new Text(
                      workoutItem.description,
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
