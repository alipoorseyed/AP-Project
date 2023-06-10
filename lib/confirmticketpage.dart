import 'package:flutter/material.dart';

import 'FlightResultsPageRaft.dart';
import 'HomePage.dart';
import 'completeBuyTicket.dart';

class ConfirmFlightTicketPage extends StatefulWidget {
  bool isRoundTrip;
  Flight goflight;
  Flight? returnflight;
  ConfirmFlightTicketPage({
    required this.goflight,
    this.returnflight,
    required this.isRoundTrip,
  });

  @override
  State<ConfirmFlightTicketPage> createState() => _ConfirmFlightTicketPageState();
}

class _ConfirmFlightTicketPageState extends State<ConfirmFlightTicketPage> {
  String? source;

  String? destination;

  String? company;

  String? flightTime;

  String? goFlightTime;

  String? returnFlightTime;

  List<Passenger>? passengers;

  void initState(){
    source=widget.goflight.source;
    destination=widget.goflight.destination;
    company=widget.goflight.company;
    flightTime=widget.goflight.dateTime.toString();
    goFlightTime=widget.goflight.dateTime.toString();
    returnFlightTime = widget.returnflight != null ? widget.returnflight!.dateTime.toString() : '';
    passengers=widget.goflight.passengerflight;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Confirm Flight Ticket'),
          backgroundColor: Colors.indigo,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStepCircle('تعیین پرواز', true, Icons.airplanemode_active, Colors.green),
                    _buildStepLine(true, Colors.green),
                    _buildStepCircle('مشخصات مسافران', true, Icons.person, Colors.green),
                    _buildStepLine(true, Colors.green),
                    _buildStepCircle('تأیید اطلاعات', true, Icons.check, Colors.green),
                  ],
                ),
                SizedBox(height: 16.0),
                _buildTicketInformation(),
                SizedBox(height: 16.0),
                _buildPassengersInformation(),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'کد تخفیف',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Perform off code check
                        ////////////////
                        ///
                        ///
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                      ),
                      child: Text('بررسی'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ////////////////////
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return homepage();
                        }
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: Text('تأیید اطلاعات'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCircle(String text, bool isActive, IconData iconData, Color color) {
    final activeColor = Colors.green;
    final inactiveColor = Colors.grey;

    return Column(
      children: [
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeColor : inactiveColor,
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
          style: TextStyle(color: isActive ? activeColor : inactiveColor),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive, Color color) {
    final activeColor = Colors.green;
    final inactiveColor = Colors.grey;

    return Expanded(
      child: Container(
        height: 2.0,
        color: isActive ? activeColor : inactiveColor,
      ),
    );
  }

  Widget _buildTicketInformation() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اطلاعات بلیط',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              _buildInfoItem('مبدا :', source!),
              _buildInfoItem('مقصد :', destination!),
              _buildInfoItem('شرکت هواپیمایی :', company!),
              if (widget.isRoundTrip) _buildInfoItem('تاریخ و زمان پرواز رفت :', goFlightTime!),
              if (widget.isRoundTrip) _buildInfoItem('تاریخ و زمان پرواز برگشت :', returnFlightTime!),
              if (!widget.isRoundTrip) _buildInfoItem('تاریخ و زمان پرواز :', flightTime!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
          ),
          Text(value),
        ],
      ),
    );
  }
  Widget _buildPassengersInformation() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اطلاعات مسافران',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: passengers!.length,
              itemBuilder: (BuildContext context, int index) {
                final passenger = passengers![index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'مسافر ${index + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      _buildInfoItem('اسم کامل :', '${passenger.firstName} ${passenger.lastName}'),
                      _buildInfoItem('جنسیت :', '${passenger.gender}'),
                      _buildInfoItem('کد ملی :', passenger.meliCode),
                      _buildInfoItem(
                        'تاریخ تولد :',
                        '${passenger.birthdayDay}/${passenger.birthdayMonth}/${passenger.birthdayYear}',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}