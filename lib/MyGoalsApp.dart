import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_goals_app/GoalsPage.dart';

class MyGoalsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "MyGoalsApp",
        theme: ThemeData.light(),
        home: GoalsPage(),
        debugShowCheckedModeBanner: false,
    );
  }
}
