import 'package:flutter/material.dart';
import 'BottomBar.dart';

class homepage extends StatefulWidget {
   homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Easy Charter",style: TextStyle(color: Colors.black)) ,
            centerTitle: true,
            backgroundColor: Colors.amberAccent,
        ),
        backgroundColor: Colors.tealAccent,
        body:
        Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center ,
            children: [
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
                child: TextButton(onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context){
                      return Bar(index: 0);
                    }
                    ),
                  );
                }, child: Text("Domestic flight",style: TextStyle(color: Colors.black,fontSize: 18),)),
              ),
              SizedBox(height: 20),
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
                child: TextButton(onPressed: (){},child: Text("International flights",style: TextStyle(color: Colors.black,fontSize: 18))),
              ),
            ],
          ),
        ) ,
        bottomNavigationBar: Bar(index: 0),
      ),
    );
  }
}
