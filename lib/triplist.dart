import 'dart:io';

import 'package:flutter/material.dart';

import 'BottomBar.dart';


class TripsListPage extends StatefulWidget {
  String username;

  TripsListPage({required this.username});

  @override
  _TripsListPageState createState() => _TripsListPageState();
}

class _TripsListPageState extends State<TripsListPage> {
  List<Flight> nofilteredFlights = [];
  List<Flight> filteredFlights = [];

  TextEditingController shomareSefareshController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  final String ip = '172.20.10.5';
  final int port = 2486;
  String respon="";
  String parvaz="";
  List<String> parvazfinal=[];
  bool ansewr=true;
  List<String> tarikh=[];
  String tarikhfinal="";

  // @override
  // void initState() async{
  //   super.initState();
  //   parvaz = await sendMessage();
  //   if(parvaz=="noFlights"){
  //     ansewr=false;
  //   }else{
  //     parvazfinal = parvaz.split("\n");
  //     for(int i=0 ; i<parvazfinal.length ; i++){
  //       tarikh = parvazfinal[i].split("-")[5].split("/");
  //       tarikhfinal = tarikh[0]+"-"+tarikh[1]+"-"+tarikh[2];
  //       nofilteredFlights.add(Flight(source: parvazfinal[i].split("-")[1], destenition: parvazfinal[i].split("-")[2], time: int.parse(parvazfinal[i].split("-")[3]), cost: double.parse(parvazfinal[i].split("-")[4]), company: parvazfinal[i].split("-")[0] , shomare_sefaresh: parvazfinal[i].split("-")[6], date:DateTime.parse(tarikhfinal) ));
  //     }
  //   }
  //   filteredFlights = nofilteredFlights;
  // }
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    parvaz = await sendMessage();
    if (parvaz == "noFlights") {
      setState(() {
        ansewr = false;
      });
    } else {
      setState(() {
        parvazfinal = parvaz.split("\n");
        for (int i = 0; i < parvazfinal.length; i++) {
          tarikh = parvazfinal[i].split("-")[6].split("/");
          tarikhfinal = tarikh[0] + "-" + tarikh[1] + "-" + tarikh[2];
          nofilteredFlights.add(Flight(
            source: parvazfinal[i].split("-")[2],
            destenition: parvazfinal[i].split("-")[3],
            time: int.parse(parvazfinal[i].split("-")[4]),
            cost: double.parse(parvazfinal[i].split("-")[5]),
            company: parvazfinal[i].split("-")[1],
            shomare_sefaresh: parvazfinal[i].split("-")[7],
            date: DateTime.parse(tarikhfinal),
          ));
        }
        filteredFlights = nofilteredFlights;
      });
    }
  }


  void applyFilters() {
    String filterShomareSefaresh = shomareSefareshController.text.toLowerCase().trim();

    setState(() {
      filteredFlights = nofilteredFlights.where((flight) {
        bool shomareSefareshMatches = flight.shomare_sefaresh.toLowerCase().contains(filterShomareSefaresh);

        bool dateMatches = true;
        if (fromDate != null && toDate != null) {
          dateMatches = flight.date.isAfter(fromDate!) && flight.date.isBefore(toDate!.add(Duration(days: 1)));
        }

        return shomareSefareshMatches && dateMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set text direction to right-to-left
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'لیست سفر ها',
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: shomareSefareshController,
                decoration: InputDecoration(
                  labelText: 'شماره سفارش',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: fromDate ?? DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2025),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            fromDate = pickedDate;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text(
                        fromDate != null ? 'از: ${fromDate!.toString().split(' ')[0]}' : 'انتخاب تاریخ شروع',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo[600],
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: toDate ?? DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2025),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            toDate = pickedDate;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text(
                        toDate != null ? 'تا: ${toDate!.toString().split(' ')[0]}' : 'انتخاب تاریخ پایان',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo[600],
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: applyFilters,
                child: Text(
                  'جستجو',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[700],
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(ansewr?"لیست پرواز ها":"پروازی موجود نیست"),
              SizedBox(height: 10.0),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredFlights.length,
                  itemBuilder: (context, index) {
                    final flight = filteredFlights[index];
                    return Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          '${flight.source} to ${flight.destenition}\n${flight.shomare_sefaresh}', // Display source to destination
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${flight.date.toString().split(' ')[0]}, ${flight.time}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Text(
                          '${(flight.cost/1000000).toStringAsFixed(2)} -میلیون تومان ${flight.company}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
        bottomNavigationBar: Bar(username: widget.username,index: 2),
      ),
    );
  }
  Future<String> sendMessage() async {
      try {
        final serverSocket = await Socket.connect(ip, port);
        print('connected');
        serverSocket.write("client-getUserFlights-${widget.username},");
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

    return respon;
  }
}
class Flight {
  final String shomare_sefaresh;
  final int time;
  final double cost;
  final String company;
  final DateTime date;
  final String source;
  final String destenition;

  Flight({
    required this.source,
    required this.destenition,
    required this.time,
    required this.cost,
    required this.company,
    required this.shomare_sefaresh,
    required this.date,
  });
}
