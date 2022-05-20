///Used for implementation of main widget

import 'package:flutter/material.dart';
import 'goals_page.dart';
import 'constant_texts.dart';

class MyGoalsApp extends StatelessWidget {
  const MyGoalsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ConstantTexts.myGoalsApp,
      theme: ThemeData.light(),
      home: const GoalsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
