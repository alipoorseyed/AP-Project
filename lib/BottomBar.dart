import 'package:untitled/HomePage.dart';
import 'package:untitled/log.dart';
import 'package:flutter/material.dart';
import 'package:untitled/triplist.dart';

import 'accountInfo.dart';
import 'moneypage.dart';

class Bar extends StatefulWidget {
  final int index;
  String username;
  //const Bar({Key? key, required this.index}) : super(key: key);
  Bar({required this.username,required this.index});

  @override
  State<Bar> createState() => _BarState();
}

class _BarState extends State<Bar> {
  void hompage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => homepage(username: widget.username,)),
    );
  }

  void userInformationTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountInfoPage(username: widget.username)),
    );
  }
  void flightListonTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripsListPage(username: widget.username)),
    );
  }
  void budgetonTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  MoneyPage(username: widget.username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.5),
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'صفحه اصلی',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'حساب کاربری',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: 'لیست سفر ها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'موجودی و تراکنش ها',
          ),
        ],
        currentIndex: widget.index,
        unselectedItemColor: Colors.blueGrey[400],
        selectedItemColor: Colors.amber[600],
        onTap: (index) {
          switch (index) {
            case 0:
              hompage();
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
      ),
    );
  }
}

