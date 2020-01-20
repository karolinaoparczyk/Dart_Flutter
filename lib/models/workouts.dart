import 'dart:async';
import 'package:ipm1920_p2/database/database.dart';
import 'package:mobx/mobx.dart';
import 'workoutmodel.dart';
part 'workouts.g.dart';

class Workouts = WorkoutsBase with _$Workouts;
abstract class WorkoutsBase with Store {
  @observable
  ObservableList<WorkoutModel> workouts = ObservableList.of([]);

  @computed
  int get numberOfWorkouts => workouts.length;

  @action
  Future<void> initWorkouts() async {
    await _getWorkouts().then((onValue) {
      workouts = ObservableList.of(onValue);
    });
  }

  @action
  void addWorkout(WorkoutModel newWorkout) {
    workouts.add(newWorkout);
  }

  Future<List<WorkoutModel>> _getWorkouts() async {
    final Future<List<WorkoutModel>> retrievedWorkouts = main();
    return retrievedWorkouts;
  }
}