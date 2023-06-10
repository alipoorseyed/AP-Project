import 'package:flutter/material.dart';

import 'FlightBookingPage.dart';
import 'FlightBookingPageint.dart';
import 'FlightResultsPageRaft.dart';
import 'completeBuyTicket.dart';
class FlightSearchResultsPageBargasht extends StatefulWidget {
  final String source;
  final String destination;
  final DateTime dateTimeone;
  final bool Roundtrip;
  final DateTime? dataTimetwo;
  final int pass;
  Flight sourceflight;
  final bool international;

  FlightSearchResultsPageBargasht({required this.sourceflight,required this.source, required this.destination, required this.dateTimeone,this.dataTimetwo,required this.Roundtrip,required this.pass,required this.international});

  @override
  _FlightSearchResultsPageBargashtState createState() => _FlightSearchResultsPageBargashtState();
}

class _FlightSearchResultsPageBargashtState extends State<FlightSearchResultsPageBargasht> {
  DateTime selectedDate = DateTime.now();
  List<String> flightCompanies = ['iran air', 'mahan air', 'saha', 'asman'];
  List<String> selectedCompanies = ['iran air', 'mahan air', 'saha', 'asman'];
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

  void initState() {
    super.initState();
    flights = [
      Flight(source: widget.source, destination: widget.destination, time: 10, cost: 2, company: 'iran air', dateTime: widget.dateTimeone),
      Flight(source: widget.source, destination: widget.destination, time: 0, cost: 1, company: 'mahan air', dateTime: widget.dateTimeone),
      Flight(source: widget.source, destination: widget.destination, time: 14, cost: 3, company: 'saha', dateTime: widget.dateTimeone),
      Flight(source: widget.source, destination: widget.destination, time: 16, cost: 1, company: 'asman', dateTime: widget.dateTimeone),
    ];
    for (var i = 0; i < flightCompanies.length; i++) {
      show.add(true);
    }
    for (var i = 0; i < flights.length; i++) {
      selectedflights.add(flights[i]);
    }
    selectedflights.sort((a, b) => a.time.compareTo(b.time));
    roundtrip=widget.Roundtrip;
    selectedDate=widget.dataTimetwo!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back)) ,
        title: Row(
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
                        child: Text('زود ترین'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'latest',
                        child: Text('دیر ترین'),
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
                            return FlightBookingApp();
                          }),
                        );
                      }else{
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return FlightBookingAppint();
                          }),
                        );
                      }
                    },
                    child: Text("تعویض پرواز"),
                  )
                ],
              ),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ConfirmbuyTicketPage(
                                    srcflight: widget.sourceflight,
                                    numberOfPassengers: widget.pass,
                                    dstflight: flight,
                                  );
                                },
                              ),
                            );
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
                          '${flight.cost} میلیون تومان',
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
      case 'iran air':
        return 'assets/Iran_Air.png';
      case 'mahan air':
        return 'assets/Mahan_Air.png';
      case 'saha':
        return 'assets/Saha_air.png';
      case 'asman':
        return 'assets/aseman.png';
      default:
        return '';
    }
  }


  void returnToSearchPage() {}

  void selectPreviousDate() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context){
          return FlightSearchResultsPageBargasht(sourceflight: widget.sourceflight, source: widget.source, destination: widget.destination, dateTimeone: widget.dateTimeone, Roundtrip: widget.Roundtrip, pass: widget.pass,international: widget.international,);
        }
        ),
      );
  }

  void selectNextDate() {
      selectedDate = selectedDate.add(Duration(days: 1));
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context){
          return FlightSearchResultsPageBargasht(sourceflight: widget.sourceflight, source: widget.source, destination: widget.destination, dateTimeone: widget.dateTimeone, Roundtrip: widget.Roundtrip, pass: widget.pass,international: widget.international,);
        }
        ),
      );
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
