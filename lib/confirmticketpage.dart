import 'dart:io';

import 'package:flutter/material.dart';

import 'FlightResultsPageRaft.dart';
import 'HomePage.dart';
import 'completeBuyTicket.dart';

class ConfirmFlightTicketPage extends StatefulWidget {
  bool isRoundTrip;
  Flight goflight;
  Flight? returnflight;
  String username;
  ConfirmFlightTicketPage({
    required this.username,
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

  String? sourcecompany;

  String? destinationcompany;

  String? flightTimeraft;

  String? flightTimebargasht;

  String? goFlightTime;

  String? returnFlightTime;

  List<Passenger>? passengers;

  String? region1;

  String? region2;

  double? budgetraft;

  double? budgetbargasht;

  double? finalbudget;

  final String ip = '172.20.10.5';
  final int port = 2486;
  String respon="";
  String respondiscount="";
  TextEditingController discountcontroller = TextEditingController();

  void initState(){
    source=widget.goflight.source;
    destination=widget.goflight.destination;
    sourcecompany=widget.goflight.company;
    destinationcompany=widget.returnflight != null ? widget.returnflight!.company: '';
    flightTimeraft=widget.goflight.time.toString();
    flightTimebargasht=widget.returnflight != null ? widget.returnflight!.time.toString(): '';
    goFlightTime=widget.goflight.dateTime.toString().split(" ")[0];
    returnFlightTime = widget.returnflight != null ? widget.returnflight!.dateTime.toString().split(" ")[0] : '';
    passengers=widget.goflight.passengerflight;
    budgetraft=widget.goflight.cost;
    budgetbargasht=widget.returnflight != null ? widget.returnflight!.cost : 0;
    if(widget.goflight.international==true){
      region1 = "int";
    }else{
      region1 = "domestic";
    }
    if(widget.returnflight != null){
      if(widget.returnflight!.international==true){
        region2 = "int";
      }else{
        region2 = "domestic";
      }
    }
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
            child: Builder(
              builder: (context) {
                return Column(
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
                    Builder(
                      builder: (context) {
                        return Row(
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
                                controller: discountcontroller,
                              ),
                            ),
                            SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () async{
                                String ansdiscount = await sendMessagediscount();
                                if(ansdiscount=="invalid"){
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            "خطا", textAlign: TextAlign.right),
                                        content: Center(
                                            child: Text(
                                              "کد تخفیف اشتباه است .",
                                              textAlign: TextAlign.center,)
                                        ),
                                        actions: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(onPressed: () {
                                              Navigator.of(context).pop();
                                            }, child: Text("تایید")),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }else{
                                  budgetraft=budgetraft!*((double.parse(ansdiscount))/100);
                                  widget.goflight.cost=budgetraft!;
                                  if(widget.isRoundTrip){
                                    budgetbargasht=budgetbargasht!*((double.parse(ansdiscount))/100);
                                    widget.returnflight!.cost=budgetbargasht!;
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            "اعلان", textAlign: TextAlign.right),
                                        content: Center(
                                            child: Text(
                                              "کد تخفیف ثبت شد .",
                                              textAlign: TextAlign.center,)
                                        ),
                                        actions: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(onPressed: () {
                                              Navigator.of(context).pop();
                                            }, child: Text("تایید")),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                              ),
                              child: Text('بررسی'),
                            ),
                          ],
                        );
                      }
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async{
                          String ans = await sendMessage();
                          if(ans=="valid"){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      "اعلان", textAlign: TextAlign.right),
                                  content: Center(
                                      child: Text(
                                        "خرید با موفیقت انجام شد .",
                                        textAlign: TextAlign.center,)
                                  ),
                                  actions: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context){
                                            return homepage(username: widget.username,);
                                          }
                                          ),
                                        );
                                      }, child: Text("تایید")),
                                    )
                                  ],
                                );
                              },
                            );
                          }else{
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      "اعلان", textAlign: TextAlign.right),
                                  content: Center(
                                      child: Text(
                                        "موجودی حساب شما کافی نیست .",
                                        textAlign: TextAlign.center,)
                                  ),
                                  actions: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context){
                                            return homepage(username: widget.username,);
                                          }
                                          ),
                                        );
                                      }, child: Text("تایید")),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: Text('تأیید اطلاعات و خرید .'),
                      ),
                    ),
                  ],
                );
              }
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
              _buildInfoItem('شرکت هواپیمایی رفت :', sourcecompany!),
              if (widget.isRoundTrip) _buildInfoItem('شرکت هواپیمایی برگشت :', destinationcompany!),
              _buildInfoItem('تاریخ پرواز رفت :', goFlightTime!),
              if (widget.isRoundTrip) _buildInfoItem('تاریخ پرواز برگشت :', returnFlightTime!),
               _buildInfoItem('زمان پرواز رفت : ', flightTimeraft!),
              if (widget.isRoundTrip) _buildInfoItem('زمان پرواز برگشت :', flightTimebargasht!),
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
  Future<String> sendMessage() async {
    try {
      final serverSocket = await Socket.connect(ip, port);
      print('connected');
      if(widget.isRoundTrip){
        serverSocket.write("client-buyFlight-${widget.username}-true-${widget.goflight.company}/${widget.goflight.source}/${widget.goflight.destination}/${widget.goflight.time}/${widget.goflight.cost.toStringAsFixed(0)}/${widget.goflight.dateTime.toString().split(" ")[0].split("-")[0]}#${widget.goflight.dateTime.toString().split(" ")[0].split("-")[1]}#${widget.goflight.dateTime.toString().split(" ")[0].split("-")[2]}/${widget.goflight.code}/${region1}\\${widget.returnflight!.company}/${widget.returnflight!.source}/${widget.returnflight!.destination}/${widget.returnflight!.time}/${widget.returnflight!.cost.toStringAsFixed(0)}/${widget.returnflight!.dateTime.toString().split(" ")[0].split("-")[0]}#${widget.returnflight!.dateTime.toString().split(" ")[0].split("-")[1]}#${widget.returnflight!.dateTime.toString().split(" ")[0].split("-")[2]}/${widget.returnflight!.code}/${region2}-${passengers!.length},");
      }else{
        serverSocket.write("client-buyFlight-${widget.username}-false-${widget.goflight.company}/${widget.goflight.source}/${widget.goflight.destination}/${widget.goflight.time}/${widget.goflight.cost.toStringAsFixed(0)}/${widget.goflight.dateTime.toString().split(" ")[0].split("-")[0]}#${widget.goflight.dateTime.toString().split(" ")[0].split("-")[1]}#${widget.goflight.dateTime.toString().split(" ")[0].split("-")[2]}/${widget.goflight.code}/${region1}-${passengers!.length},");
      }
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
  Future<String> sendMessagediscount() async {
    if(discountcontroller.text.isNotEmpty) {
      try {
        final serverSocket = await Socket.connect(ip, port);
        print('connected');
        serverSocket.write("client-Discount-${discountcontroller.text},");
        serverSocket.flush();
        print('write');
        await serverSocket.listen((socket) {
          respondiscount = String.fromCharCodes(socket).trim().substring(2);
          setState(() {});
          print("this is show: " + respondiscount);
        }).asFuture();

        serverSocket.close();
      } catch (e) {
        print('Error: $e');
      }
    }
    return respondiscount;
  }
}