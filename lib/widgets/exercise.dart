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

  const ExerciseWidget({Key key, @required this.exerciseItem}) : super(key: key);

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
                          child: new Text(exerciseItem.name,
                            style: new TextStyle(fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,),
                        ),
                        new Center(
                          child: _getImage(exerciseItem.image),
                        ),
                        new Center(
                            child: new Text(exerciseItem.description,
                              style: new TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.justify,)
                        )
                      ]
                  )
              )
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