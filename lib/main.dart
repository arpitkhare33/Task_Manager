import 'package:flutter/material.dart';
import 'package:note_keeper/screens/note_list.dart';
import 'package:note_keeper/screens/note_detail.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.purple,

      ),
        home: NoteKeeper(),
    );
  }
}
