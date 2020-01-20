import 'dart:typed_data';
import 'package:meta/meta.dart';

class WorkoutModel {
  Uint8List imageName;
  final String name;
  final String description;
  final String imageBin;

  WorkoutModel({@required this.name, @required this.description,
    @required this.imageBin});

  factory WorkoutModel.fromJson(Map<String, dynamic> parsedJson) {
    return WorkoutModel(
      name: parsedJson['name'],
      description: parsedJson['description'],
      imageBin: parsedJson['imageBin'].cast<int>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'description': this.description,
      'imageBin': this.imageBin,
    };
  }
}