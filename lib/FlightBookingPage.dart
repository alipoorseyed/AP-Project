import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/FlightResultsPageRaft.dart';
import 'package:untitled/HomePage.dart';
class FlightBookingApp extends StatelessWidget {
  String username;
  FlightBookingApp({
    required this.username,
});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flight Booking',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: FlightBookingPage(username: username,),
      ),
    );
  }
}

class FlightBookingPage extends StatefulWidget {
  String username;
  FlightBookingPage({
    required this.username,
});
  @override
  _FlightBookingPageState createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  String selectedSource = '';
  String selectedDestination = '';
  bool isRoundTrip = false;
  DateTime? departureDate;
  DateTime? returnDate;
  int adultCount = 1;
  int kidCount = 0;
  int babyCount = 0;
  final String ip = '172.20.10.5';
  final int port = 2486;
  String respon="";
  String city = "";
  List<String> citie = [];
  List<String> cities = [];

  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    city = await sendMessage();
    citie = city.split("-");
    for (int i = 0; i < citie.length-1; i++) {
      if (!cities.contains(citie[i])) {
        cities.add(citie[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPassengers = adultCount + kidCount + babyCount;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('تعیین پرواز'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return homepage(username: widget.username,);
              }),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isRoundTrip = false;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: isRoundTrip ? Colors.white : Colors.indigo[700],
                            ),
                            child: Text(
                              'یک طرفه',
                              style: TextStyle(
                                  color: isRoundTrip ? Colors.blue : Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isRoundTrip = true;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: isRoundTrip ? Colors.indigo[700] : Colors.white,
                            ),
                            child: Text(
                              'دو طرفه',
                              style: TextStyle(
                                  color: isRoundTrip ? Colors.white : Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: selectedSource,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSource = newValue!;
                          if (selectedDestination == selectedSource) {
                            selectedDestination = '';
                          }
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: '',
                          child: Text('انتخاب'),
                        ),
                        ...cities.map((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                      ],
                      decoration: InputDecoration(
                        labelText: 'مبدأ',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: selectedDestination,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDestination = newValue!;
                          if (selectedSource == selectedDestination) {
                            selectedSource = '';
                          }
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: '',
                          child: Text('انتخاب'),
                        ),
                        ...cities
                            .where((city) => city != selectedSource)
                            .map((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                      ],
                      decoration: InputDecoration(
                        labelText: 'مقصد',
                      ),
                    ),

                    SizedBox(height: 16.0),
                    DateTimePicker(
                      labelText: 'تاریخ رفت',
                      selectedDate: departureDate,
                      selectDate: (DateTime date) {
                        setState(() {
                          departureDate = date;
                        });
                      },
                    ),
                    if (isRoundTrip)
                      SizedBox(height: 16.0),
                    if (isRoundTrip)
                      DateTimePicker(
                        labelText: 'تاریخ برگشت',
                        selectedDate: returnDate,
                        selectDate: (DateTime date) {
                          setState(() {
                            returnDate = date;
                          });
                        },
                      ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PassengerCountDialog(
                              adultCount: adultCount,
                              kidCount: kidCount,
                              babyCount: babyCount,
                              updateCount: (int adult, int kid, int baby) {
                                setState(() {
                                  adultCount = adult;
                                  kidCount = kid;
                                  babyCount = baby;
                                });
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        color: Colors.grey[200],
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'مسافران',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              '$totalPassengers نفر',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if(isRoundTrip){
                          if(selectedSource!='' && selectedDestination!='' && departureDate!=null && returnDate!=null){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return FlightSearchResultsPageRaft(username: widget.username,source: selectedSource, destination: selectedDestination, dateTimeone: departureDate!,dataTimetwo: returnDate,Roundtrip: isRoundTrip,pass: totalPassengers,international: false,);
                                },)
                            );
                          }else{
                            showDialog(
                              context: context,
                              builder: (context)
                              {
                                return AlertDialog(

                                  title: Text("خطا"),
                                  content:
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return Center(
                                          child: Text(
                                              "لطفا تمام فیلد ها را پر کنید"
                                          ),
                                        );
                                      },),
                                  ),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.of(context).pop();
                                    }, child: Text("تایید")),
                                  ],
                                );
                              },
                            );
                          }
                        }else{
                          if(selectedSource!='' && selectedDestination!='' && departureDate!=null){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return FlightSearchResultsPageRaft(username: widget.username,source: selectedSource, destination: selectedDestination, dateTimeone: departureDate!,dataTimetwo: returnDate,Roundtrip: isRoundTrip,pass: totalPassengers,international: false,);
                                },)
                            );
                          }else{
                            showDialog(
                              context: context,
                              builder: (context)
                              {
                                return AlertDialog(
                                  title: Text("خطا"),
                                  content:
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return Center(
                                          child: Text(
                                              "لطفا تمام فیلد ها را پر کنید"
                                          ),
                                        );
                                      },),
                                  ),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.of(context).pop();
                                    }, child: Text("تایید")),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      child: Text('جست و جوی پرواز ها'),
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
  Future<String> sendMessage() async {
    try {
      final serverSocket = await Socket.connect(ip, port);
      print('connected');
      serverSocket.write("client-FlightBookingDomestic,");
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

class DateTimePicker extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final Function(DateTime) selectDate;
  final bool isEnabled;

  DateTimePicker({required this.labelText, this.selectedDate, required this.selectDate, this.isEnabled = true});

  Future<void> _selectDate(BuildContext context) async {
    if (!isEnabled) return; // Skip if disabled
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        color: isEnabled ? Colors.grey[200] : Colors.grey[300], // Change color based on isEnabled
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              labelText,
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : 'انتخاب تاریخ ',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class PassengerCountDialog extends StatefulWidget {
  final int adultCount;
  final int kidCount;
  final int babyCount;
  final Function(int, int, int) updateCount;

  PassengerCountDialog({
    required this.adultCount,
    required this.kidCount,
    required this.babyCount,
    required this.updateCount,
  });

  @override
  _PassengerCountDialogState createState() => _PassengerCountDialogState();
}

class _PassengerCountDialogState extends State<PassengerCountDialog> {
  late int adultCount;
  late int kidCount;
  late int babyCount;

  @override
  void initState() {
    super.initState();
    adultCount = widget.adultCount;
    kidCount = widget.kidCount;
    babyCount = widget.babyCount;
  }

  void _updateCount() {
    widget.updateCount(adultCount, kidCount, babyCount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تعداد مسافران'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('بزرگسال'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (adultCount > 0) {
                          adultCount--;
                        }
                      });
                    },
                  ),
                  Text(adultCount.toString()),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        adultCount++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('کودک'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (kidCount > 0) {
                          kidCount--;
                        }
                      });
                    },
                  ),
                  Text(kidCount.toString()),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        kidCount++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('نوزاد'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (babyCount > 0) {
                          babyCount--;
                        }
                      });
                    },
                  ),
                  Text(babyCount.toString()),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        babyCount++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('لغو'),
        ),
        TextButton(
          onPressed: _updateCount,
          child: Text('تایید'),
        ),
      ],
    );
  }
}

