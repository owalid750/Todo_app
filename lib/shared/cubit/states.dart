import 'package:flutter/material.dart';

abstract class AppStates {}

class AppIntialState extends AppStates {}

class AppChangeBottomNavBar extends AppStates {
  final List<Widget> screen;

  AppChangeBottomNavBar(this.screen);
}

class AppCreateDataBaseState extends AppStates {}


class AppInsertToDataBaseState extends AppStates {}

class AppGetFromDataBaseState extends AppStates {}
class AppGetataBaseLoadingState extends AppStates {}

class AppChangeBottomSheetState extends AppStates {}
class AppUpdateDataBaseState extends AppStates {}
class AppDelDataBaseState extends AppStates {}