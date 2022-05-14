import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyGoalsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "MyGoalsApp",
        theme: ThemeData.light(),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amber,
              title: Center(
                  child: Text(
                "Мои цели",
                style: TextStyle(color: Colors.black),
              )
              ),
            ),
            body: Center(child: GoalsPage())
        )
    );
  }
}
