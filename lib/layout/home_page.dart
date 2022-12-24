


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_todo/constants.dart';
import 'package:tasks_todo/layout/cubit/cubit.dart';
import 'package:tasks_todo/layout/cubit/states.dart';
import 'package:tasks_todo/localization/localization_methods.dart';
import 'package:tasks_todo/main.dart';
import 'package:tasks_todo/models/language.dart';
import 'package:tasks_todo/modules/archived.dart';
import 'package:tasks_todo/modules/done.dart';
import 'package:tasks_todo/modules/tasks.dart';

class myHomePage extends StatelessWidget
{



  var formKey=GlobalKey<FormState>();
  var scaffoldKey =GlobalKey<ScaffoldState>();


  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();



  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context) => appCubit()..createDatabase(),
      child: BlocConsumer<appCubit,appStates>(
        listener: (context, state) {
          // if (state is appInsertIntoDatabaseState)
          //   {
          //     Navigator.pop(context);
          //     titleController.clear();
          //     timeController.clear();
          //     dateController.clear();
          //   }
        },
        builder:(context, state) {
          appCubit cubit=appCubit.get(context);
          return Scaffold(

            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(getTranslated(context, '${cubit.titles[cubit.currentIndex]}')!),
              actions: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: DropdownButton(
                      underline: SizedBox(),
                      icon: Icon(
                        Icons.language,
                        color: Colors.white,
                      ),
                      items: Language.languageList()
                          .map<DropdownMenuItem<Language>>(
                              (lang) => DropdownMenuItem(
                            value: lang,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  lang.flag,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(lang.name)
                              ],
                            ),
                          )
                      ).toList(),
                      onChanged: (value){
                        Language lang=value as Language;
                        // print(lang.name);
                        _changeLanguage(lang,context);
                        //print(lang.languageCode);
                      }
                  ),
                )
              ],
            ),
            body: state is! appGetDatabaseLoadingState? cubit.screens[cubit.currentIndex]
            :Center(child: CircularProgressIndicator()),

            floatingActionButton: FloatingActionButton(

              child: Icon(cubit.fabIcon),
              onPressed: (){
                if(cubit.IsBottomSheetOpened)
                {
                  if(formKey.currentState!.validate()){

                    cubit.insertIntoDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text).then((value) {
                          Navigator.pop(context);
                         titleController.clear();
                         timeController.clear();
                         dateController.clear();
                    });
                    // insertIntoDatabase(
                    //   title: titleController.text,
                    //   time: timeController.text,
                    //   date: dateController.text,).then((value)
                    // {
                    //
                    //   getDataFromDatabase(database).then((value)
                    //   {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   allTasks=value;
                    //     //   IsBottomSheetOpened=false;
                    //     //   fabIcon=Icons.edit;
                    //     //
                    //     //   titleController.clear();
                    //     //   timeController.clear();
                    //     //   dateController.clear();
                    //     // });
                    //   });
                    // }).catchError((error){
                    //   print(error.toString());
                    // });
                  }
                }else
                {
                  scaffoldKey.currentState!.showBottomSheet((context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(topRight:Radius.circular(20.0),topLeft: Radius.circular(20.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.title,color: Colors.blue,),
                                  labelText: getTranslated(context, 'Task_Title'),//'Task title',
                                ),
                                validator: (value){
                                  if(value!.isEmpty)
                                  {
                                    return getTranslated(context, 'Task_Title_Empty');//'Task title can not be empty !';
                                  }
                                },
                              ),
                              SizedBox(height: 10.0,),
                              TextFormField(
                                controller: timeController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.date_range_outlined,color: Colors.blue,),
                                  labelText: getTranslated(context, 'Task_Time'),//'Task time',
                                ),
                                readOnly: true,
                                onTap: (){
                                  showTimePicker(context: context, initialTime: TimeOfDay.now())
                                      .then((value) {
                                    timeController.text=value!.format(context).toString();
                                  });
                                },
                                validator: (value){
                                  if(value!.isEmpty)
                                  {
                                    return getTranslated(context, 'Task_Time_Empty');//'Task time can not be empty !';
                                  }
                                },
                              ),
                              SizedBox(height: 10.0,),
                              TextFormField(
                                controller: dateController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.watch_later,color: Colors.blue,),
                                  labelText: getTranslated(context, 'Task_Date'),//'Task date',
                                ),
                                readOnly: true,
                                validator: (value){
                                  if(value!.isEmpty)
                                  {
                                    return getTranslated(context, 'Task_Date_Empty');//'Task date can not be empty !';
                                  }
                                },
                                onTap: (){
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2024-08-11')
                                  ).then((value){
                                    dateController.text=DateFormat.yMMMd().format(value!);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).closed.then((value) {
                    cubit.changeBottomSheetState(IsShow: false, icon: Icons.edit);
                    //IsBottomSheetOpened=false;
                    // setState(() {
                    //   fabIcon=Icons.edit;
                    // });
                  });

                  cubit.changeBottomSheetState(IsShow: true, icon: Icons.add);
                  //IsBottomSheetOpened=true;
                  // setState(() {
                  //   fabIcon=Icons.add;
                  // });
                }
              },

              tooltip: getTranslated(context, 'Add_Task'),
            ),

            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.task),label: getTranslated(context, 'Tasks')),
                BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline),label: getTranslated(context, 'Done')),
                BottomNavigationBarItem(icon: Icon(Icons.archive),label:getTranslated(context, 'Archived') ),
              ],

              currentIndex: cubit.currentIndex,

              onTap: (index){
                cubit.changeIndex(index);
              },
            ),

          );
        },
      ),
    );
  }





}




void _changeLanguage(Language lang ,context) async
{
  Locale _temp = await setLocale(lang.languageCode);
  MyApp.setLocale( context, _temp);
}


