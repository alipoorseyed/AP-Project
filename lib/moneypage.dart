 import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
 import 'package:untitled/BottomBar.dart';
class MoneyPage extends StatefulWidget {
  String username;

  MoneyPage({required this.username});

  @override
  _MoneyPageState createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> {
  double initialBalance=0;
  List<Tarakonesh> tarakoneshList=[];
  late double accountBalance=0;
  final String ip = '172.20.10.5';
  final int port = 2486;
  String respon="";
  String tarakonesh="";
  List<String> tarakoneshfinal=[];
  bool existtarakonesh=true;
  bool increases = false;
  TextEditingController moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    tarakonesh = await sendMessage();
    initialBalance = double.parse(tarakonesh.split("\n")[0]);
    accountBalance = initialBalance;
    if (tarakonesh.split("\n")[1] == "invalid") {
      existtarakonesh = false;
    } else {
      tarakoneshfinal = tarakonesh.split("\n");
      for (int i = 1; i < tarakoneshfinal.length; i++) {
        increases = false;
        if (tarakoneshfinal[i].split("-")[1] == "increase") {
          increases = true;
        }
        tarakoneshList.add(Tarakonesh(
          kind: "داخلی",
          increase: increases,
          codePaygiri: tarakoneshfinal[i].split("-")[3],
          cost: double.parse(tarakoneshfinal[i].split("-")[2]),
        ));
      }
    }
  }


  void increaseBalance() async{
    double enteredMoney = double.parse(moneyController.text);
    int code;
    int counter=0;
    while(true){
      counter=0;
      code = generateRandomNumber();
      for(int i=0 ; i<tarakoneshList.length ; i++){
        if(int.parse(tarakoneshList[i].codePaygiri!)==code){
          counter++;
        }
      }
      if(counter==0){
        break;
      }
    }
    String asn = await sendMessagebudget(code.toString());
    setState(() {
      tarakoneshList.add(Tarakonesh(kind: "داخلی", increase: true, codePaygiri:code.toString() , cost: enteredMoney));
      accountBalance += enteredMoney;
      moneyController.clear();
    });
  }

  String getTransactionType(bool increase) {
    return increase ? "افزایش شارژ بابت واریز" : "کاهش شارژ بابت خرید خدمات";
  }

  Color getAmountColor(bool increase) {
    return increase ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('صفحه پول'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(
                      'موجودی حساب',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    trailing: Text(
                      '${accountBalance.toStringAsFixed(2)} تومان',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'افزایش موجودی',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: moneyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'مقدار را وارد کنید',
                          labelStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: increaseBalance,
                      child: Text('افزایش موجودی'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (tarakoneshList.isEmpty)
                  Text(
                    'اطلاعاتی وجود ندارد',
                    style: TextStyle(fontSize: 16),
                  ),
                if (tarakoneshList.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(3),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'کد پیگیری',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'نوع تراکنش',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'مبلغ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        for (Tarakonesh tarakonesh in tarakoneshList)
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(tarakonesh.codePaygiri ?? ''),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(getTransactionType(tarakonesh.increase ?? false)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '${tarakonesh.cost.toStringAsFixed(2)} تومان',
                                  style: TextStyle(
                                    color: getAmountColor(tarakonesh.increase ?? false),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Directionality(
          textDirection: TextDirection.rtl, // Set text direction of bottom navigation bar to right-to-left
          child: Bar(username: widget.username,index: 3),
        ),
      ),
    );
  }
  Future<String> sendMessage() async {
    try {
      final serverSocket = await Socket.connect(ip, port);
      print('connected');
      serverSocket.write("client-moneyPage-${widget.username},");
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
  Future<String> sendMessagebudget(String code) async {
    if(moneyController.text.isNotEmpty) {
      try {
        final serverSocket = await Socket.connect(ip, port);
        print('connected');
        serverSocket.write(
            "client-increaseBudget-${widget.username}-${moneyController
                .text}-${code},");
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
    }

    return respon;
  }
  int generateRandomNumber() {
    Random random = Random();
    int min = 100000; // Minimum 6-digit number
    int max = 999999; // Maximum 6-digit number
    return min + random.nextInt(max - min);
  }
}

class Tarakonesh {
  String? kind = "";
  bool? increase = false;
  String? codePaygiri = "";
  double cost;

  Tarakonesh({
    required this.kind,
    required this.increase,
    required this.codePaygiri,
    required this.cost,
  });
}

