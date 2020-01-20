part of '../models/workouts.dart';

mixin _$Workouts on WorkoutsBase, Store {
  Computed<int> _$numberOfWorkoutsComputed;

  @override
  int get numberOfWorkouts => (_$numberOfWorkoutsComputed ??=
          Computed<int>(() => super.numberOfWorkouts))
      .value;

  final _$workoutsAtom = Atom(name: 'WorkoutsBase.workouts');

  @override
  ObservableList<WorkoutModel> get workouts {
    _$workoutsAtom.context.enforceReadPolicy(_$workoutsAtom);
    _$workoutsAtom.reportObserved();
    return super.workouts;
  }

  @override
  set workouts(ObservableList<WorkoutModel> value) {
    _$workoutsAtom.context.conditionallyRunInAction(() {
      super.workouts = value;
      _$workoutsAtom.reportChanged();
    }, _$workoutsAtom, name: '${_$workoutsAtom.name}_set');
  }

  final _$initWorkoutsAsyncAction = AsyncAction('initWorkouts');

  @override
  Future<void> initWorkouts() {
    return _$initWorkoutsAsyncAction.run(() => super.initWorkouts());
  }
}
