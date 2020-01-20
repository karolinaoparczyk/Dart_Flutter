import 'package:meta/meta.dart';

class ExerciseModel {
  final String name;
  final dynamic description;
  final String image;
  final String video;

  ExerciseModel({@required this.name, @required this.description,
    @required this.image, @required this.video});

  factory ExerciseModel.fromJson(Map<String, dynamic> parsedJson) {
    return ExerciseModel(
      name: parsedJson['name'],
      description: parsedJson['description'],
      image: parsedJson['image'].cast<int>(),
      video: parsedJson['video'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'description': this.description,
      'image': this.image,
      'video': this.video,
    };
  }
}