import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/FlightResultsPageBargasht.dart';
import 'package:untitled/HomePage.dart';

import 'FlightBookingPage.dart';
import 'FlightBookingPageint.dart';
import 'completeBuyTicket.dart';
class FlightSearchResultsPageRaft extends StatefulWidget {
  final String source;
  final String destination;
  final DateTime dateTimeone;
  final bool Roundtrip;
  final DateTime? dataTimetwo;
  final int pass;
  final bool international;
  String username;

  FlightSearchResultsPageRaft({
    required this.username,
    required this.source,
    required this.destination,
    required this.dateTimeone,
    this.dataTimetwo,
    required this.Roundtrip,
    required this.pass,
    required this.international,
  });

  @override
  _FlightSearchResultsPageRaftState createState() => _FlightSearchResultsPageRaftState();
}

class _FlightSearchResultsPageRaftState extends State<FlightSearchResultsPageRaft> {
  DateTime selectedDate = DateTime.now();
  List<String> flightCompanies = [];
  List<String> selectedCompanies = [];
  int hour1 = 0;
  int hour2 = 23;
  int counter = 0;
  bool roundtrip = true;
  List<bool> show = [];
  String selectedSortOption = 'earliest';
  Flight? temp;
  List<Flight> flights = [];
  List<Flight> selectedflights = [];
  TimeOfDay minFlightTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay maxFlightTime = TimeOfDay(hour: 23, minute: 59);
  final String ip = '172.20.10.5';
  final int port = 2486;
  String respon="";
  String flightlist="";
  List<String> flightlistfinal=[];
  bool intern=false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchFlights();
  }

  Future<void> fetchFlights() async {
    flightlist = await sendMessage();
    if (flightlist != "noFlights") {
      flightlistfinal = flightlist.split("\n");
      for (int i = 0; i < flightlistfinal.length; i++) {
        intern = false;
        if (flightlistfinal[i].split("-")[7] == "int") {
          intern = true;
        }
        flights.add(Flight(
          source: flightlistfinal[i].split("-")[1],
          destination: flightlistfinal[i].split("-")[2],
          time: int.parse(flightlistfinal[i].split("-")[3]),
          cost: double.parse(flightlistfinal[i].split("-")[4]),
          company: flightlistfinal[i].split("-")[0],
          dateTime: widget.dateTimeone,
          code: int.parse(flightlistfinal[i].split("-")[6]),
          international: intern,
        ));
        if (flightCompanies.contains(flightlistfinal[i].split("-")[0]) == false) {
          flightCompanies.add(flightlistfinal[i].split("-")[0]);
          selectedCompanies.add(flightlistfinal[i].split("-")[0]);
        }
      }
    }
    for (var i = 0; i < flightCompanies.length; i++) {
      show.add(true);
    }
    for (var i = 0; i < flights.length; i++) {
      selectedflights.add(flights[i]);
    }
    selectedflights.sort((a, b) => a.time.compareTo(b.time));
    roundtrip = widget.Roundtrip;
    selectedDate = widget.dateTimeone;
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        IconButton(onPressed: (){
          if(widget.international==false){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return FlightBookingApp(username: widget.username,);
              }),
            );
          }else{
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return FlightBookingAppint(username: widget.username,);
              }),
            );
          }
        }, icon: Icon(Icons.arrow_back)) ,
        automaticallyImplyLeading: false,
        title: Row(
          textDirection: TextDirection.rtl,
          children: [
            Text('${widget.source} به ${widget.destination}'),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              SizedBox(height: 12.5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStepCircle('انتخاب پرواز', true, Icons.airplanemode_active),
                    _buildStepLine(false),
                    _buildStepCircle('مسافران', false, Icons.person),
                    _buildStepLine(false),
                    _buildStepCircle('تایید اطلاعات', false, Icons.check),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () {
                      selectPreviousDate();
                    },
                  ),
                  Text(
                    '${selectedDate.day}/${selectedDate.month}',
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () {
                      selectNextDate();
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: selectedSortOption,
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: 'earliest',
                        child: Text('نزدیک ترین'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'latest',
                        child: Text('دورترین'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'cheapest',
                        child: Text('ارزان ترین'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'expensivest',
                        child: Text('گران ترین'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSortOption = newValue!;
                        sortflights(selectedflights, newValue);
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("فیلتر های خود را انتخاب کنید"),
                            content: StatefulBuilder(builder: (context, setState) {
                              return Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: flightCompanies.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        trailing: Text(
                                          flightCompanies[index],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        leading: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (show[index]) {
                                                show[index] = false;
                                                selectedCompanies.remove(flightCompanies[index]);
                                              } else {
                                                show[index] = true;
                                                selectedCompanies.add(flightCompanies[index]);
                                              }
                                            });
                                          },
                                          icon: Icon(show[index]
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Text("بازه زمانی خود را انتخاب کنید"),
                                  SizedBox(height: 4),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (hour1 > 0) {
                                                hour1--;
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.remove),
                                        ),
                                        Text("${hour1}", style: TextStyle(fontSize: 16)),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (hour1 + 1 < hour2) {
                                                hour1++;
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                        Text("تا", style: TextStyle(fontSize: 16)),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (hour2 > hour1 + 1) {
                                                hour2--;
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.remove),
                                        ),
                                        Text("${hour2}", style: TextStyle(fontSize: 16)),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (hour2 < 23) {
                                                hour2++;
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    for (int i = 0; i < flights.length; i++) {
                                      counter = 0;
                                      for (int j = 0; j < selectedCompanies.length; j++) {
                                        if (flights[i].company == selectedCompanies[j]) {
                                          counter++;
                                        }
                                      }
                                      if (counter > 0) {
                                        if (flights[i].time >= hour1 && flights[i].time <= hour2) {
                                          if (selectedflights.contains(flights[i]) == false) {
                                            selectedflights.add(flights[i]);
                                          }
                                        } else {
                                          selectedflights.remove(flights[i]);
                                        }
                                      } else {
                                        selectedflights.remove(flights[i]);
                                      }
                                    }
                                    sortflights(selectedflights, selectedSortOption);
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text("اعمال"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("فیلتر ها"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if(widget.international==false){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return FlightBookingApp(username: widget.username,);
                          }),
                        );
                      }else{
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return FlightBookingAppint(username: widget.username,);
                          }),
                        );
                      }
                    },
                    child: Text("تعویض پرواز"),
                  )
                ],
              ),
              SizedBox(height: 6),
              Text(flightlist=="noFlights" ? "پروازی در این تاریخ موجود نیست" : "پرواز های موجود"),
              SizedBox(height: 6),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedflights.length,
                  itemBuilder: (BuildContext context, int index) {
                    Flight flight = selectedflights[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(.5),
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          if (widget.Roundtrip) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return FlightSearchResultsPageBargasht(
                                    username: widget.username,
                                    sourceflight: flight,
                                    source: widget.destination,
                                    destination: widget.source,
                                    dateTimeone: widget.dateTimeone,
                                    dateTimetwo: widget.dataTimetwo!,
                                    Roundtrip: widget.Roundtrip,
                                    pass: widget.pass,
                                    international: widget.international,
                                  );
                                },
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ConfirmbuyTicketPage(
                                    username: widget.username,
                                    srcflight: flight,
                                    numberOfPassengers: widget.pass,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        leading: Image.asset(
                          getCompanyImage(flight.company),
                          width: 100,
                          height: 55,
                        ),
                        title: Row(
                          children: [

                            Text(
                              flight.time<12?'${flight.time} AM':'${flight.time} PM',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${(flight.cost/1000000).toStringAsFixed(2)} میلیون تومان',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Text(
                          flight.company,
                          style: TextStyle(fontSize: 16),
                        ),

                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildStepCircle(String text, bool isActive, IconData iconData) {
    return Column(
      children: [
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.grey,
          ),
          child: Icon(
            iconData,
            color: Colors.white,
            size: 16.0,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          text,
          textAlign: TextAlign.right, // Align text to the right
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2.0,
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }

  String getCompanyImage(String company) {
    switch (company) {
      case 'Iran Air':
        return 'assets/Iran_Air.png';
      case 'Mahan Air':
        return 'assets/Mahan_Air.png';
      case 'Saha':
        return 'assets/Saha_air.png';
      case 'Aseman':
        return 'assets/aseman.png';
      case 'ATA':
        return 'assets/Borchin-ir-Ata Air logo png layered.png';
      case 'Kish Air':
        return 'assets/Borchin-ir-Kish Air logo png layered.png';
      case 'Zagros':
        return 'assets/Borchin-ir-Zagros Air logo png layered.png';
      case 'Caspian':
        return 'assets/Borchin-ir-caspian air logo png layered.png';
      default:
        return '';
    }
  }


  void returnToSearchPage() {}

  void selectPreviousDate() {
    selectedDate = selectedDate.subtract(Duration(days: 1));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return FlightSearchResultsPageRaft(
            username: widget.username,
            source: widget.source,
            destination: widget.destination,
            dateTimeone: selectedDate,
            Roundtrip: widget.Roundtrip,
            pass: widget.pass,
            international: widget.international,
          );
        },
      ),
    );
  }

  void selectNextDate() {
    selectedDate = selectedDate.add(Duration(days: 1));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return FlightSearchResultsPageRaft(
            username: widget.username,
            source: widget.source,
            destination: widget.destination,
            dateTimeone: selectedDate,
            Roundtrip: widget.Roundtrip,
            pass: widget.pass,
            international: widget.international,
          );
        },
      ),
    );
  }
  Future<String> sendMessage() async {
      try {
        final serverSocket = await Socket.connect(ip, port);
        print('connected');
        serverSocket.write("client-flightresult-${widget.username}-${widget.source}-${widget.destination}-${widget.dateTimeone.toString().split(" ")[0].split("-")[0]}/${widget.dateTimeone.toString().split(" ")[0].split("-")[1]}/${widget.dateTimeone.toString().split(" ")[0].split("-")[2]},");
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

void sortflights(List<Flight> x, String s) {
  if (s == 'earliest') {
    x.sort((a, b) => a.time.compareTo(b.time));
  } else if (s == 'latest') {
    x.sort((a, b) => b.time.compareTo(a.time));
  } else if (s == 'cheapest') {
    x.sort((a, b) => a.cost.compareTo(b.cost));
  } else if (s == 'expensivest') {
    x.sort((a, b) => b.cost.compareTo(a.cost));
  }
}

class Flight {
  String source = "";
  String destination = "";
  int time;
  double cost;
  int code;
  bool international;
  DateTime dateTime;
  String company = "";
  List<Passenger> passengerflight = [];

  Flight({
    required this.source,
    required this.destination,
    required this.time,
    required this.cost,
    required this.company,
    required this.dateTime,
    required this.code,
    required this.international
  });
}