import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_todo/constants.dart';
import 'package:tasks_todo/layout/cubit/cubit.dart';
import 'package:tasks_todo/layout/cubit/states.dart';
import 'package:tasks_todo/localization/localization_methods.dart';
import 'package:tasks_todo/modules/display_screen.dart';

class tasksScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return appCubit.get(context).newTasks.length>0? ListView.separated(
          itemBuilder: (context, index) => itemBuilder(map: appCubit.get(context).newTasks[index],context: context),
         separatorBuilder: (context, index) =>Padding(
           padding: getLangCode(context)==ARABIC ? const EdgeInsets.only(right:  20.0):const EdgeInsets.only(left:  20.0),
           child: Container(
             height: 1,
             width: double.infinity,
             color: Colors.grey,
           ),
         ),
          itemCount: appCubit.get(context).newTasks.length,
          physics: BouncingScrollPhysics(),
        ) :viewBuilder(context);
      },
    );
  }
}



Widget itemBuilder({Map? map,context})
{
  return Dismissible(
    background: Container(
     // color: Colors.red[600],
    child: Align(
      alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(Icons.delete,color: Colors.red,),
              SizedBox(width: 5,),
              Text(getTranslated(context, 'Delete')!,style: TextStyle(color: Colors.red),),
              Spacer(),
              Text(getTranslated(context, 'Delete')!,style: TextStyle(color: Colors.red)),
              SizedBox(width: 5,),
              Icon(Icons.delete,color: Colors.red,),

            ],
          ),
        )),
    ),
    key: UniqueKey(), //Key(map!['id'].toString()),
    onDismissed: (direction) {
      appCubit.get(context).deleteDataFromDatabase(id: map!['id']);
    },
    child: InkWell(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(map!['time'],style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.blue,
            ),
            SizedBox(width: 20.0,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    map['title'] ,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize:18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Text(map['date'],style: TextStyle(color: Colors.grey),),

                ],
              ),
            ),
            SizedBox(width: 20.0,),
            IconButton(
                onPressed: (){
                  appCubit.get(context).updateDatabase(status: 'done', id: map['id']);
                },
                icon: Icon(
                  Icons.check_box,
                  color:map['status']=='done'? Colors.green: Colors.grey,
                ),
                highlightColor: Colors.lightGreen,
                splashColor: Colors.green
            ),
            SizedBox(width: 10.0,),
            IconButton(
              onPressed: (){
                appCubit.get(context).updateDatabase(status: 'archived', id: map['id']);
              },
                icon: Icon(
                    Icons.archive,
                  color:map['status']=='archived'? Colors.red: Colors.grey,
                ),
            ),
          ],
        ),
      ),
    onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => display_screen(taskText: map['title']),));
    },
    ),

  );
}



Widget viewBuilder(context)
{
  return  Center(
    child: Column(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Image(image: AssetImage('assets/board.jpg'),),
                  SizedBox(height: 10.0,),
                  Text(
                    getTranslated(context, 'Add_your_tasks_to_manage_your_time')!,
                   // 'Add your tasks to manage your time ',
                    style: TextStyle(
                        fontSize:20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent),
                  ),
                ],
              ),
  );
}