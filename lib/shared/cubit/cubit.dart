import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../../screans/archived_tasks.dart';
import '../../screans/done_tasks.dart';
import '../../screans/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);
  //
  int selectedIndex = 0;
  //
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  //
  Database? db;
  //
  IconData icon = Icons.edit;
  //
  bool isBotttomSheetShown = false;
  //

  static const List<Widget> screens = <Widget>[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  static const List<String> titles = <String>[
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  toggle(index) {
    selectedIndex = index;
    emit(AppChangeBottomNavBar(screens));
  }

  void changeBottosheetstate({
    bool? isShow,
    IconData? icone,
  }) {
    isBotttomSheetShown = isShow!;
    icon = icone!;
    emit(AppChangeBottomSheetState());
  }

  //CREATE DATABASE
  void createDB() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (db, version) {
        print("database created");
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER  PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) => {
                  print("table created"),
                })
            .catchError((error) {
          print("error when creating table ${error.toString()}");
        });
      },
      onOpen: (db) {
        GetDataFromDataBase(db);
        print("database opened");
      },
    ).then((value) {
      db = value;
      emit(AppCreateDataBaseState());
    });
  }

  //INSERT TO DATABASE
  insertToDB({String? title, String? time, String? date}) async {
    await db?.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES ("$title", "$date", "$time", "new")')
          .then((value) {
        print("$value insert successfuly");
        emit(AppInsertToDataBaseState());
        GetDataFromDataBase(db);
      }).catchError((error) {
        print("error in insert new Record ${error.toString()}");
      });
      return Future(() {});
    });
  }

  //Get Data From DataBase
  void GetDataFromDataBase(db) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetataBaseLoadingState());
    db!.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach(
        (element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archiveTasks.add(element);
          }
        },
      );
      emit(AppGetFromDataBaseState());
    });
  }

  //UPDATE DATA
  UpdateData({
    String? status,
    int? id,
  }) async {
    db!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [
      '$status',
      id,
    ]).then((value) {
      GetDataFromDataBase(db);
      emit(AppUpdateDataBaseState());
    });
  }

  //DEL data
  delData({
    int? id,
  }) async {
    db!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {});
  }
}
