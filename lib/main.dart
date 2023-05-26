import 'package:flutter/material.dart';
import 'package:untitled/log.dart';
import 'package:untitled/signUp.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
   MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return loginpage();
  }
}