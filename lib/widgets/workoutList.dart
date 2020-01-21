import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipm1920_p2/models/workoutmodel.dart';
import 'package:ipm1920_p2/widgets/workout.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class WorkoutList extends StatelessWidget {
  WorkoutList(
      {@required this.workouts,
      @required this.itemSelectedCallback});
  final List<WorkoutModel> workouts;
  final ScrollController _rrectController = ScrollController();
  final ValueChanged<WorkoutModel> itemSelectedCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
      ),
      body: Container(
        child: Observer(
          builder: (_) => workouts.isNotEmpty
              ? DraggableScrollbar.semicircle(
                  controller: _rrectController,
                  backgroundColor: Colors.grey,
                  heightScrollThumb: 50,
                  child: ListView(
                    controller: _rrectController,
                    children: workouts.reversed.map((workoutItem) {
                      return new FlatButton(
                        child: new WorkoutWidget(workoutItem: workoutItem),
                        onPressed: () => itemSelectedCallback(workoutItem),
                      );
                    }).toList(),
                  ))
              : new Center(
                  child: new CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
