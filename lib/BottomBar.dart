import 'package:ap_project/log.dart';
import 'package:flutter/material.dart';

class Bar extends StatefulWidget {
  final int index;
  const Bar({ Key? key, required this.index }): super(key: key);
  @override
  State<Bar> createState() =>
      _BarState();
}

class _BarState extends State<Bar> {
    void homepage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginpage()),
      );
  }

  void userInformationTapped() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginpage()),
      );
  }

  void flightListonTapped() {
    
  }

  void budgetonTapped() {
   
  }

  @override
  Widget build(BuildContext context) {
    return 
     BottomNavigationBar(

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'user info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: 'flight list',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'budget',
          ),
        ],
        currentIndex: widget.index,
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 0:

              break;
            case 1:
              userInformationTapped();
              break;
            case 2:
              flightListonTapped();
              break;
            case 3:
              budgetonTapped();
              break;
          }
        },
      );
  }
}
