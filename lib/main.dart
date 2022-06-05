import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_oserver.dart';
import 'layout/home_screen.dart';

void main(List<String> args) async {
  // WidgetsFlutterBinding
  //     .ensureInitialized(); //بيتاكد ان كل حاجه خلصت في الميثود وبعديم يرن الابلكيششن

  BlocOverrides.runZoned(
    () {
      runApp( MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
