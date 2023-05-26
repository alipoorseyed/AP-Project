import 'package:flutter/material.dart';
import 'package:untitled/signUp.dart';

class loginpage extends StatefulWidget {
   loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  bool show = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.tealAccent,
        appBar: AppBar(
          title:Text("Easy Charter",style: TextStyle(color: Colors.black)) ,
          centerTitle: true,
          backgroundColor: Colors.amberAccent,
        ),
        body:
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child:SingleChildScrollView(
              child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Log in",style: TextStyle(fontSize: 40,color: Colors.red)),
                SizedBox(height: 50),
                Material(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        hintText: "UserName",
                        icon: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(Icons.perm_identity,color: Colors.grey[500]),
                        )
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  elevation: 20,
                  borderRadius: BorderRadius.circular(40),
                  shadowColor: Colors.grey[200],
                ),
                SizedBox(height: 25),
                Material(
                  child: TextField(
                    obscureText: show,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(3.8, 7.6, 3.8, 7.6),
                      hintText: "Password",
                      icon: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(Icons.lock_outline,color: Colors.grey[500]),
                      ),
                      suffix: IconButton(onPressed: (){
                        setState(() {
                          if(show){
                            show = false;
                          }else{
                            show = true;
                          }
                        });
                      }, icon: Icon(show== true?Icons.remove_red_eye:Icons.remove_red_eye_outlined)),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  elevation: 20,
                  borderRadius: BorderRadius.circular(40),
                  shadowColor: Colors.grey[200],
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: Colors.black12
                    ),
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextButton(onPressed: (){}, child: Text("log in",style: TextStyle(color: Colors.black,fontSize: 18),)),
                ),
                SizedBox(height: 15),
                Builder(
                  builder: (context) {
                    return Container(
                      height: 45,
                      width: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 3,
                            color: Colors.black12
                        ),
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextButton(
                          onPressed: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder:(context){
                                return sign();
                              }
                              ),
                            );
                          },
                          child: Text("sign up",style: TextStyle(color: Colors.black,fontSize: 16),)
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
}
