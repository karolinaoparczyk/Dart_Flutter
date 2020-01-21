import 'dart:typed_data';
import 'package:ipm1920_p2/models/exercisemodel.dart';
import 'package:meta/meta.dart';

class WorkoutModel {
  Uint8List imageName;
  final String name;
  final String description;
  final String imageBin;
  List<ExerciseModel> exercises;

  WorkoutModel({@required this.name, @required this.description,
    @required this.imageBin, this.exercises});

  factory WorkoutModel.fromJson(Map<String, dynamic> parsedJson) {
    return WorkoutModel(
      name: parsedJson['name'],
      description: parsedJson['description'],
      imageBin: parsedJson['imageBin'].cast<int>(),
      exercises: parsedJson['exercises'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'description': this.description,
      'imageBin': this.imageBin,
      'exercises': this.exercises,
    };
  }

  setExercises(List<ExerciseModel> exercises){
    this.exercises = exercises;
  }
}