
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_todo/constants.dart';
import 'package:tasks_todo/layout/cubit/states.dart';
import 'package:bloc/bloc.dart';
import 'package:tasks_todo/localization/localization_methods.dart';
import 'package:tasks_todo/modules/archived.dart';
import 'package:tasks_todo/modules/done.dart';
import 'package:tasks_todo/modules/tasks.dart';

class appCubit extends Cubit<appStates>
{
  appCubit():super(initialState());

  static appCubit get(context)=>BlocProvider.of(context);

  List<Widget> screens=[
    tasksScreen(),
    done(),
    archived(),
  ];

  List<String> titles=[
    "Tasks",
    "Done",
    "Archived",
  ];

  int currentIndex=0;

  late Database database;

  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];



  bool IsBottomSheetOpened=false;
  IconData fabIcon=Icons.edit;



  void changeIndex(int index)
  {
    currentIndex=index;
    emit(appChangeBottomNavState());
  }



  void changeBottomSheetState({
    required bool IsShow,
    required IconData icon,
})
  {
    IsBottomSheetOpened=IsShow;
    fabIcon=icon;
    emit(appChangeBottomSheetStateState());
  }

  /// ///////////////////////////////////  SQFLite Database  /////////////////////////////////////////////

  void createDatabase()
  {
    emit(appGetDatabaseLoadingState());
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database db, int version)
      {
        //print('DATABASE CREATED.');
        db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
        .then((value) {
        // print('TABLE CREATED.');
        }).catchError((Error){
         // print('Error when creating Table' + Error.toString());
        });
      },
      onOpen: (database)
      {
       // print('DATABASE OPENED.');
        getDataFromDatabase(database);
      },
    ).then((value) {
       database=value;
       emit(appCreateDatabaseState());
     });
  }


  Future insertIntoDatabase({
    required String title,
    required String time,
    required String date,
  })async
  {
    await database.transaction( (txn) {
      return txn.rawInsert('INSERT Into tasks (title,date,time,status) VALUES ("$title","$date","$time","new")')
        .then((value) {
        emit(appInsertIntoDatabaseState());
        getDataFromDatabase(database);
        }).catchError((Error){
       // print('Error in insertion into database '+ Error.toString());
      });
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];


    database.rawQuery('SElECT * FROM tasks').then((value)
    {
      value.forEach((element) {
        if(element['status']=='new')
          {
            newTasks.add(element);
          }
        else if(element['status']=='done')
          {
            doneTasks.add(element);
          }
        else
          {
            archivedTasks.add(element);
          }
      });
      emit(appGetDatabaseState());
    });
  }


 void updateDatabase({
  required String status,
  required int id,
 })async
  {
     database.rawUpdate('UPDATE tasks SET status=? where id=?',['$status',id]).then((value)
     {
       getDataFromDatabase(database);
       emit(appUpdateDatabaseState());
     });
  }


  void deleteDataFromDatabase({required int id,})
  {
    database.rawDelete('DELETE FROM tasks  where id=?',[id]).then((value)
    {
      getDataFromDatabase(database);
      emit(appDeleteFromDatabaseState());
    });
  }





}