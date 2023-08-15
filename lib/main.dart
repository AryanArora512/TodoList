import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todolist/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo list app",
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: HexColor("#292b29"),
              foregroundColor: Colors.black12)),
      home: HomeScreen(),
    );
  }
}
