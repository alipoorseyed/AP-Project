import 'package:flutter/material.dart';
import 'package:untitled/BottomBar.dart';
class AccountInfoPage extends StatefulWidget {
  final String? profilePicture;
  final String? name;
  final double? accountMoney;
  final String? email;
  String? nameValue;
  String? meliCodeValue;
  String? birthdayValue;
  String? genderValue;

  AccountInfoPage({
    this.profilePicture,
    this.name,
    this.accountMoney,
    this.email,
    this.nameValue,
    this.meliCodeValue,
    this.birthdayValue,
    this.genderValue,
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
                          widget.name!,
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            SizedBox(width: 4.0),
                            Text(
                              '${widget.accountMoney!.toStringAsFixed(2)} تومان',
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
                      widget.email!,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    IconButton(
                      onPressed: () {
                        // Handle email update button
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
                                     ),
                                      SizedBox(height: 25,),
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: "رمز عبور جدید",
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          actions: [
                            TextButton(onPressed: (){
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
                      onPressed: () {
                        setState(() {
                          isEditMode = false;
                          // Save the updated values here
                          widget.nameValue = updatedNameValue ?? widget.nameValue;
                          widget.meliCodeValue = updatedMeliCodeValue ?? widget.meliCodeValue;
                          widget.birthdayValue = updatedBirthdayValue ?? widget.birthdayValue;
                          widget.genderValue = updatedGenderValue ?? widget.genderValue;
                        });
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
                buildInfoField('نام : ', widget.nameValue),
                buildInfoField('کد ملی : ', widget.meliCodeValue),
                buildInfoField('تاریخ تولد : ', widget.birthdayValue),
                buildInfoField('جنسیت : ', widget.genderValue),
                SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Bar(index: 1),
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
                  if (label == 'Name') {
                    updatedNameValue = value;
                  } else if (label == 'Meli Code') {
                    updatedMeliCodeValue = value;
                  } else if (label == 'Birthday') {
                    updatedBirthdayValue = value;
                  } else if (label == 'Gender') {
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
      return updatedNameValue ?? widget.nameValue;
    } else if (label == 'Meli Code') {
      return updatedMeliCodeValue ?? widget.meliCodeValue;
    } else if (label == 'Birthday') {
      return updatedBirthdayValue ?? widget.birthdayValue;
    } else if (label == 'Gender') {
      return updatedGenderValue ?? widget.genderValue;
    }
    return null;
  }
}

