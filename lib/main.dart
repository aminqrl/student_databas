import 'package:flutter/material.dart';
import 'package:student_database/screens/add_student_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

          primarySwatch: Colors.lightBlue
      ),
      home: const AddStudentScreen(),
    );
  }
}


