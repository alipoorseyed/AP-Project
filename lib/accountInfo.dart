import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/BottomBar.dart';
class AccountInfoPage extends StatefulWidget {
  String username;

  AccountInfoPage({
    required this.username,
  });

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  bool isEditMode = false;
  String? updatedNameValue;
  String? updatedMeliCodeValue;
  String? updatedBirthdayValue;
  String? updatedGenderValue;

  String? profilePicture;
  String? name;
  double? accountMoney;
  String? email;
  String? nameValue;
  String? meliCodeValue;
  String? birthdayValue;
  String? genderValue;
  String? password;

  final String ip = '172.20.10.5';
  final int port = 2486;
  String respon="";
  String responpassword="";
  String respongmail="";
  String responInfo="";
  String info="";
  TextEditingController gmailcontroller = TextEditingController();
  TextEditingController oldpasswordcontroller = TextEditingController();
  TextEditingController newpasswordcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    info = await sendMessage();
    name = widget.username;
    email = info.split("-")[2];
    password = info.split("-")[0];
    accountMoney = double.parse(info.split("-")[1]);
    nameValue = info.split("-")[3];
    meliCodeValue = info.split("-")[4];
    birthdayValue = info.split("-")[5];
    genderValue = info.split("-")[6];
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('حساب کاربری'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage: AssetImage("assets/levi.webp"),
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name!,
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            SizedBox(width: 4.0),
                            Text(
                              '${accountMoney!.toStringAsFixed(2)} تومان',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                Text(
                  'اطلاعات حساب کاربری',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ایمیل:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      email!,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    IconButton(
                      onPressed: () {
                        // Handle email update button
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("تغییر ایمیل"),
                              content: StatefulBuilder(builder: (context, setState) {
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 35),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 40),
                                          TextField(
                                            decoration: InputDecoration(
                                              hintText: "ایمیل جدید",
                                            ),
                                            textAlign: TextAlign.center,
                                            controller: gmailcontroller,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              actions: [
                                TextButton(onPressed: (){
                                  setState(() async{
                                    if(gmailcontroller.text.isNotEmpty){
                                      email = gmailcontroller.text;
                                      String gmail = await sendMessagegmail();
                                    }
                                    Navigator.of(context).pop();
                                  });
                                }, child: Text("تایید"))
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("تغییر رمز عبور"),
                          content: StatefulBuilder(builder: (context, setState) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35),
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 40),
                                     TextField(
                                       decoration: InputDecoration(
                                         hintText: "رمز عبور قدیم",
                                       ),
                                       textAlign: TextAlign.center,
                                       controller: oldpasswordcontroller,
                                     ),
                                      SizedBox(height: 25,),
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: "رمز عبور جدید",
                                        ),
                                        textAlign: TextAlign.center,
                                        controller: newpasswordcontroller,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          actions: [
                            TextButton(onPressed: ()async{
                              if(oldpasswordcontroller.text==password){
                                if(newpasswordcontroller.text.isNotEmpty){
                                  password = newpasswordcontroller.text;
                                  String passwordans = await sendMessagepassword();
                                }
                              }
                              Navigator.of(context).pop();
                            }, child: Text("تایید"))
                          ],
                        );
                      },
                    );
                  },
                  child: Text('ویرایش کلمه عبور'),
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اطلاعات شخصی',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    isEditMode
                        ? ElevatedButton(
                      onPressed: () async {
                        isEditMode = false;
                        // Save the updated values here
                        nameValue = updatedNameValue ?? nameValue;
                        meliCodeValue = updatedMeliCodeValue ?? meliCodeValue;
                        birthdayValue = updatedBirthdayValue ?? birthdayValue;
                        genderValue = updatedGenderValue ?? genderValue;
                        String info = await sendMessageinfo();
                        setState(() {}); // Move this setState call here
                      },
                      child: Text('ذخیره'),
                    )
              : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditMode = true;
                        });
                      },
                      child: Text('تغییر'),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                buildInfoField('نام : ', nameValue),
                buildInfoField('کد ملی : ', meliCodeValue),
                buildInfoField('تاریخ تولد : ', birthdayValue),
                buildInfoField('جنسیت : ', genderValue),
                SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Bar(username: widget.username,index: 1),
      ),
    );
  }

  Widget buildInfoField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16.0),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  if (label == 'نام : ') {
                    updatedNameValue = value;
                  } else if (label == 'کد ملی : ') {
                    updatedMeliCodeValue = value;
                  } else if (label == 'تاریخ تولد : ') {
                    updatedBirthdayValue = value;
                  } else if (label == 'جنسیت : ') {
                    updatedGenderValue = value;
                  }
                });
              },
              initialValue: isEditMode ? getInitialValue(label) : value,
              enabled: isEditMode,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  String? getInitialValue(String label) {
    if (label == 'Name') {
      return updatedNameValue ?? nameValue;
    } else if (label == 'Meli Code') {
      return updatedMeliCodeValue ?? meliCodeValue;
    } else if (label == 'Birthday') {
      return updatedBirthdayValue ?? birthdayValue;
    } else if (label == 'Gender') {
      return updatedGenderValue ?? genderValue;
    }
    return null;
  }
  Future<String> sendMessage() async {
      try {
        final serverSocket = await Socket.connect(ip, port);
        print('connected');
        serverSocket.write("client-AccountInfo-${widget.username},");
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
  Future<String> sendMessagepassword() async {
    if(newpasswordcontroller.text.isNotEmpty) {
      try {
        final serverSocket = await Socket.connect(ip, port);
        print('connected');
        serverSocket.write("client-changePassword-${widget.username}-${newpasswordcontroller.text},");
        serverSocket.flush();
        print('write');
        await serverSocket.listen((socket) {
          responpassword = String.fromCharCodes(socket).trim().substring(2);
          setState(() {});
          print("this is show: " + responpassword);
        }).asFuture();

        serverSocket.close();
      } catch (e) {
        print('Error: $e');
      }
    }

    return responpassword;
  }
  Future<String> sendMessagegmail() async {
    if(gmailcontroller.text.isNotEmpty) {
      try {
        final serverSocket = await Socket.connect(ip, port);
        print('connected');
        serverSocket.write("client-changeEmail-${widget.username}-${gmailcontroller.text},");
        serverSocket.flush();
        print('write');
        await serverSocket.listen((socket) {
          respongmail = String.fromCharCodes(socket).trim().substring(2);
          setState(() {});
          print("this is show: " + respongmail);
        }).asFuture();

        serverSocket.close();
      } catch (e) {
        print('Error: $e');
      }
    }

    return respongmail;
  }
  Future<String> sendMessageinfo() async {
      try {
        final serverSocket = await Socket.connect(ip, port);
        print('connected');
        serverSocket.write(
            "client-changeInfo-${widget.username}-${nameValue}-${meliCodeValue}-${birthdayValue}-${genderValue},");
        serverSocket.flush();
        print('write');
        await serverSocket.listen((socket) {
          responInfo = String.fromCharCodes(socket).trim().substring(2);
          setState(() {});
          print("this is show: " + responInfo);
        }).asFuture();

        serverSocket.close();
      } catch (e) {
        print('Error: $e');
      }

    return responInfo;
  }


}

