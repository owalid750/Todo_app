
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titileController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertToDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) => Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: Text(
                    "${AppCubit.titles.elementAt(AppCubit.get(context).selectedIndex)}")),
            body: ConditionalBuilder(
                condition: state is! AppGetataBaseLoadingState,
                builder: (context) =>
                    AppCubit.screens[AppCubit.get(context).selectedIndex],
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator())),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "Archive")
              ],
              currentIndex: AppCubit.get(context).selectedIndex,
              onTap: (index) {
                AppCubit.get(context).toggle(index);
              },
              selectedItemColor: Colors.blue,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: false,
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (AppCubit.get(context).isBotttomSheetShown) {
                    if (formkey.currentState!.validate()) {
                      AppCubit.get(context).insertToDB(
                          title: titileController.text,
                          time: timeController.text,
                          date: dateController.text);
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) {
                            return Container(
                              padding:  EdgeInsets.all(20),
                              color: Colors.grey[200],
                              child: Form(
                                key: formkey,
                                autovalidateMode: AutovalidateMode.always,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      onTap: () {
                                        print('title tapped');
                                      },
                                      controller: titileController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter title of task";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          label: Text("Task Title"),
                                          prefixIcon: Icon(Icons.title),
                                          border: OutlineInputBorder()),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                          print(value.format(context));
                                        }).catchError((error) {
                                          print(
                                              "error in time picker tap ${error.toString()}");
                                        });
                                      },
                                      controller: timeController,
                                      keyboardType: TextInputType.datetime,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter time of task";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          label: Text("Task Time"),
                                          prefixIcon:
                                              Icon(Icons.watch_later_outlined),
                                          border: OutlineInputBorder()),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      onTap: () {
                                        showDatePicker(
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    "2022-06-22"),
                                                context: context,
                                                initialDate: DateTime.now())
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMEd()
                                                  .format(value!);
                                          print(DateFormat.yMMMEd()
                                              .format(value));
                                        }).catchError((error) {
                                          print(
                                              "error in time picker tap ${error.toString()}");
                                        });
                                      },
                                      controller: dateController,
                                      keyboardType: TextInputType.datetime,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter date of task";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          label: Text("Task Date"),
                                          prefixIcon:
                                              Icon(Icons.calendar_today),
                                          border: OutlineInputBorder()),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                        .closed
                        .then((value) {
                          AppCubit.get(context).changeBottosheetstate(
                              isShow: false, icone: Icons.edit);
                        });
                    AppCubit.get(context)
                        .changeBottosheetstate(isShow: true, icone: Icons.add);
                  }
                },
                child: Icon(AppCubit.get(context).icon))),
      ),
    );
  }
}
