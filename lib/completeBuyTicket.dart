import 'package:untitled/BottomBar.dart';
import 'package:flutter/material.dart';

import 'FlightResultsPageRaft.dart';
import 'HomePage.dart';
import 'confirmticketpage.dart';

class ConfirmbuyTicketPage extends StatefulWidget {
  final int numberOfPassengers;
  Flight srcflight;
  Flight? dstflight;
  ConfirmbuyTicketPage({required this.numberOfPassengers,required this.srcflight,this.dstflight});

  @override
  _ConfirmbuyTicketPageState createState() => _ConfirmbuyTicketPageState();
}

class _ConfirmbuyTicketPageState extends State<ConfirmbuyTicketPage> {
  List<Passenger> passengers = [];
  bool isBuyEnabled = false;

  @override
  void initState() {
    super.initState();
    addPassengers(widget.numberOfPassengers);
  }

  void addPassengers(int count) {
    setState(() {
      for (int i = 0; i < count; i++) {
        passengers.add(Passenger());
      }
    });
  }

  void addPassenger() {
    setState(() {
      passengers.add(Passenger());
    });
  }

  void removePassenger(int index) {
    setState(() {
      passengers.removeAt(index);
    });
  }

  void validateForm() {
    bool isFormComplete = passengers.every((passenger) =>
    passenger.firstName.isNotEmpty &&
        passenger.lastName.isNotEmpty &&
        passenger.gender != null &&
        passenger.meliCode.isNotEmpty &&
        passenger.birthdayDay != null &&
        passenger.birthdayMonth != null &&
        passenger.birthdayYear != null);

    setState(() {
      isBuyEnabled = isFormComplete;
    });
  }

  void buyTickets() {
    if (isBuyEnabled) {
      for(int i=0 ; i<passengers.length ; i++){
        widget.srcflight.passengerflight.add(passengers[i]);
        if(widget.dstflight!=null){
          widget.dstflight!.passengerflight.add(passengers[i]);
        }
      }
      if(widget.dstflight!=null){
        Navigator.of(context).push(
          MaterialPageRoute(builder:(context){
            return ConfirmFlightTicketPage(goflight: widget.srcflight,returnflight: widget.dstflight,isRoundTrip: true);
          }
          ),
        );
      }else{
        Navigator.of(context).push(
          MaterialPageRoute(builder:(context){
            return ConfirmFlightTicketPage(goflight: widget.srcflight,isRoundTrip: false);
          }
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set text direction to right-to-left
      child: Scaffold(
        appBar: AppBar(
          title: Text('تکمیل بلیت پرواز'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStepCircle('انتخاب پرواز', true, Icons.airplanemode_active),
                        _buildStepLine(true),
                        _buildStepCircle('مسافران', true, Icons.person),
                        _buildStepLine(false),
                        _buildStepCircle('تایید اطلاعات', false, Icons.check),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: passengers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildPassengerCard(passengers[index], index);
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: addPassenger,
                      child: Text('افزودن مسافر جدید'),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: buyTickets,
                      child: Text('خرید'),
                      style: ElevatedButton.styleFrom(
                        primary: isBuyEnabled ? null : Colors.grey,
                      ),
                    ),
                  ],
                );
              }
          ),
        ),
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

  Widget _buildPassengerCard(Passenger passenger, int index) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('اطلاعات مسافر', style: TextStyle(fontSize: 16.0)),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    removePassenger(index);
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                passenger.firstName = value;
                validateForm();
              },
              decoration: InputDecoration(labelText: 'نام (انگلیسی)'),
            ),
            TextField(
              onChanged: (value) {
                passenger.lastName = value;
                validateForm();
              },
              decoration: InputDecoration(labelText: 'نام خانوادگی (انگلیسی)'),
            ),
            DropdownButtonFormField<String>(
              onChanged: (value) {
                setState(() {
                  passenger.gender = value!;
                  validateForm();
                });
              },
              value: passenger.gender,
              decoration: InputDecoration(labelText: 'جنسیت'),
              items: [
                DropdownMenuItem(child: Text('مرد'), value: 'مرد'),
                DropdownMenuItem(child: Text('زن'), value: 'زن'),
              ],
            ),
            TextField(
              onChanged: (value) {
                passenger.meliCode = value;
                validateForm();
              },
              decoration: InputDecoration(labelText: 'کد ملی'),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: 4.0),
                      Text(
                        'تاریخ تولد:',
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    onChanged: (value) {
                      setState(() {
                        passenger.birthdayDay = value;
                        validateForm();
                      });
                    },
                    value: passenger.birthdayDay,
                    decoration: InputDecoration(labelText: 'روز'),
                    items: List.generate(31, (index) => index + 1)
                        .map((day) =>
                        DropdownMenuItem(child: Text(day.toString()), value: day))
                        .toList(),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    onChanged: (value) {
                      setState(() {
                        passenger.birthdayMonth = value;
                        validateForm();
                      });
                    },
                    value: passenger.birthdayMonth,
                    decoration: InputDecoration(labelText: 'ماه'),
                    items: List.generate(12, (index) => index + 1)
                        .map((month) =>
                        DropdownMenuItem(child: Text(month.toString()), value: month))
                        .toList(),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    onChanged: (value) {
                      setState(() {
                        passenger.birthdayYear = value;
                        validateForm();
                      });
                    },
                    value: passenger.birthdayYear,
                    decoration: InputDecoration(labelText: 'سال'),
                    items: List.generate(100, (index) => 1920 + index)
                        .map((year) =>
                        DropdownMenuItem(child: Text(year.toString()), value: year))
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Passenger {
  String firstName = '';
  String lastName = '';
  String? gender;
  String meliCode = '';
  int? birthdayDay;
  int? birthdayMonth;
  int? birthdayYear;
}

