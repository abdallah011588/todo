import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_todo/layout/cubit/cubit.dart';
import 'package:tasks_todo/layout/cubit/states.dart';
import 'package:tasks_todo/modules/tasks.dart';

class done extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return appCubit.get(context).archivedTasks.length==0 && appCubit.get(context).newTasks.length==0 && appCubit.get(context).doneTasks.length==0?
        viewBuilder(context):ListView.separated(
          itemBuilder: (context, index) => itemBuilder(map: appCubit.get(context).doneTasks[index],context: context),
          separatorBuilder: (context, index) =>Padding(
            padding: const EdgeInsets.only(left:  20.0),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
          itemCount: appCubit.get(context).doneTasks.length,
          physics: BouncingScrollPhysics(),
        );
      },
    );
  }
}
