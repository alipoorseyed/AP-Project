 import 'package:flutter/material.dart';
 import 'package:untitled/BottomBar.dart';
class MoneyPage extends StatefulWidget {
  final double initialBalance;
  final List<Tarakonesh> tarakoneshList;

  MoneyPage({required this.initialBalance, required this.tarakoneshList});

  @override
  _MoneyPageState createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> {
  late double accountBalance;
  TextEditingController moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    accountBalance = widget.initialBalance;
  }

  void increaseBalance() {
    double enteredMoney = double.parse(moneyController.text);
    setState(() {
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
                if (widget.tarakoneshList.isEmpty)
                  Text(
                    'اطلاعاتی وجود ندارد',
                    style: TextStyle(fontSize: 16),
                  ),
                if (widget.tarakoneshList.isNotEmpty)
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
                        for (Tarakonesh tarakonesh in widget.tarakoneshList)
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
          child: Bar(index: 3),
        ),
      ),
    );
  }
}

class Tarakonesh {
  String? kind = "";
  bool? increase = false;
  String? codePaygiri = "";
  int cost;

  Tarakonesh({
    required this.kind,
    required this.increase,
    required this.codePaygiri,
    required this.cost,
  });
}

