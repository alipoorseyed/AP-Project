import 'package:flutter/material.dart';
import 'package:untitled/log.dart';
import 'dart:core';
class sign extends StatefulWidget {
  sign({Key? key}) : super(key: key);

  @override
  State<sign> createState() => _signState();
}

class _signState extends State<sign> {
  RegExp passwordPattern =
  RegExp(r'^(?=.*(?:.*[aA]){2}|.*[01])(?=.*[A-Z])(?!.*(?:01|12|23|34|45|56|67|78|89))(?!.*(.)\1)(?=.*[a-zA-Z0-9]{8,}).*$');
  RegExp gmailPattern = RegExp(r'^[a-zA-Z0-9]{5,}@gmail\.com$');
  String? gmail = "";
  String? password = "";
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF2E294E),
        appBar: AppBar(
          title: Text(
            "حق چارتر",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF222043),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return loginpage();
                }),
              );
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "صفحه ثبت نام",
                    style: TextStyle(fontSize: 40, color: Color(0xFF16A0FF)),
                  ),
                  SizedBox(height: 50),
                  Material(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: "نام کاربری",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon:
                        Icon(Icons.perm_identity, color: Colors.grey[500]),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    elevation: 3,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  SizedBox(height: 25),
                  Material(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: "ایمیل",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.email, color: Colors.grey[500]),
                      ),
                      onChanged: (text) {
                        setState(() {
                          gmail = text;
                        });
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    elevation: 3,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  SizedBox(height: 25),
                  Material(
                    child: TextField(
                      obscureText: show,
                      onChanged: (pass) {
                        setState(() {
                          password = pass;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: "رمز عبور",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon:
                        Icon(Icons.lock_outline, color: Colors.grey[500]),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              show = !show;
                            });
                          },
                          icon: Icon(show
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    elevation: 3,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 50,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Color(0xFF16A0FF),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        int counter = 0;
                        if (gmailPattern.hasMatch(gmail!)) {
                          if (passwordPattern.hasMatch(password!)) {
                            counter++;
                          }
                        }
                        if (counter == 1) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return loginpage();
                            }),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("خطا", textAlign: TextAlign.right),
                                content: Container(
                                  height: 100,
                                  width: 100,
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Center(
                                        child: Text(
                                          "ایمیل یا رمز عبور خود را اشتباه وارد کرده اید",
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("باشه"),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        "ثبت نام",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}