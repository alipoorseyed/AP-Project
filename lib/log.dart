import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/BottomBar.dart';
import 'package:untitled/HomePage.dart';
import 'package:untitled/signUp.dart';
class loginpage extends StatefulWidget {
  loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  bool show = true;
  bool isHovered = false;
   final String ip = '172.20.10.5';
   final int port = 2486;
   String respon="";
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF16A0FF),
        hintColor: Color(0xFF16A0FF),
        scaffoldBackgroundColor: Color(0xFF2E294E),
        appBarTheme: AppBarTheme(
          color: Color(0xFF222043),
          foregroundColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Color(0xFF16A0FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "حق چارتر",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "صفحه ورود",
                    style: TextStyle(fontSize: 40, color: Color(0xFF16A0FF), fontFamily: 'PersianFont'),
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
                      controller:usernamecontroller ,
                    ),
                    elevation: 3,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  SizedBox(height: 25),
                  Material(
                    child: TextField(
                      obscureText: show,
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
                      controller: passwordcontroller,
                    ),
                    elevation: 3,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  SizedBox(height: 30),
                  Builder(
                    builder: (context) {
                      return Container(
                        height: 50,
                        width: 180,
                        margin: EdgeInsets.only(top: 20),
                        child: TextButton(
                          onPressed: () async{
                            String ans = await sendMessage();
                            if(ans=="valid"){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return homepage(username: usernamecontroller.text,);
                                }),
                              );
                            }else{
                              if(ans=="findError") {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          "خطا", textAlign: TextAlign.right),
                                      content: Center(
                                          child: Text(
                                            "نام کاربری پیدا نشد .",
                                            textAlign: TextAlign.center,)
                                      ),
                                      actions: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextButton(onPressed: () {
                                            Navigator.of(context).pop();
                                          }, child: Text("تایید")),
                                        )
                                      ],
                                    );
                                  },
                                );
                              }else{
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          "خطا", textAlign: TextAlign.right),
                                      content: Center(
                                          child: Text(
                                            "رمز عبور اشتباه است .",
                                            textAlign: TextAlign.center,)
                                      ),
                                      actions: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextButton(onPressed: () {
                                            Navigator.of(context).pop();
                                          }, child: Text("تایید")),
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Text(
                            "ورود",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  Builder(
                    builder: (context) {
                      return MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            isHovered = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            isHovered = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return sign();
                              }),
                            );
                          },
                          child: Text(
                            "هنوز اکانت خود را نساخته اید؟",
                            style: TextStyle(
                              fontSize: 16,
                              color: isHovered ? Colors.white : Colors.blue,
                              decoration: isHovered ? TextDecoration.underline : TextDecoration.none,
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<String> sendMessage() async {
    if (usernamecontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty) {
      try {
        final serverSocket = await Socket.connect(ip, port);
        print('connected');
        serverSocket.write("client-verifyLogin-${usernamecontroller.text}-${passwordcontroller.text},");
        serverSocket.flush();
        print('write');
        await serverSocket.listen((socket) {
          respon = String.fromCharCodes(socket).trim().substring(2);
          setState(() {});
          print("this is show: " + respon);
        }).asFuture();

        serverSocket.close();
      } catch (e) {
        print('Error: $e');
      }
    }

    return respon;
  }
}

