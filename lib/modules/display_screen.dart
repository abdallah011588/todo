
import 'package:flutter/material.dart';
import 'package:tasks_todo/localization/localization_methods.dart';

class display_screen extends StatelessWidget
{

  final String taskText;

  const display_screen({required this.taskText}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'Task_content')!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          taskText,
          style: TextStyle(fontSize: 25.0),
        ),
      ),
    );
  }
}
