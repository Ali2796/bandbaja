import 'dart:convert';
import 'dart:io';

import 'package:band_baaja/constants/ApiContants.dart';
import 'package:band_baaja/constants/app_data.dart';
import 'package:band_baaja/screens/BandStatusScreen.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File profileImage = File('');
  var isLoading = false;
  List<String> casteList = [];
  List<String> genderList = ['Male', 'Female'];
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
  var selectedDate;
  var selectedCaste;
  var gender;

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController professionController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCaste();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: HexColor('#fafafa'),

      body: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            left:40 ,
            top: 30,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child:  Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),),
                child: Padding(
                  padding: EdgeInsets.all(screenSize.height * 0.01),

                  child: Icon(Icons.arrow_back,color: AppColors.primaryColor,),
                ),
              ),
            ),
          ),
          SafeArea(
              child: Padding(
                  padding: EdgeInsets.only(
                      top: screenSize.height * 0.02,
                      left: screenSize.width * 0.1,
                      right: screenSize.width * 0.1),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppText.profileDetails,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: AppTextWeight.boldWeight,
                                      fontSize: Sizes.LARGE),
                                ),
                                SizedBox(height: screenSize.height * 0.03),
                                Center(
                                    child: SizedBox(
                                  height: screenSize.height * 0.1,
                                  width: screenSize.width * 0.22,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    fit: StackFit.expand,
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: profileImage.path == ''
                                            ? Image.asset(
                                                "assets/one.jpeg",
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                profileImage,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      Positioned(
                                          bottom: -10,
                                          right: -40,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                              _getFromGallery();
                                            },
                                            elevation: 2.0,
                                            fillColor: AppColors.primaryColor,
                                            child: Icon(Icons.camera_alt_outlined,
                                                color: Colors.white,
                                                size: screenSize.height * 0.02),
                                            padding: const EdgeInsets.all(1.0),
                                            shape: const CircleBorder(
                                                side: BorderSide(
                                                    color: Colors.white, width: 2)),
                                          )),
                                    ],
                                  ),
                                )),
                                SizedBox(height: screenSize.height * 0.03),
                                TextField(
                                  keyboardType: TextInputType.text,
                                  inputFormatters: [
                                    FilteringTextInputFormatter(
                                        RegExp(r'[a-zA-Z ]'),
                                        allow: true)
                                  ],
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                    hintText: AppText.hintFirstName,
                                    hintStyle: TextStyle(color: AppColors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.03),
                                TextField(
                                  keyboardType: TextInputType.text,
                                  inputFormatters: [
                                    FilteringTextInputFormatter(
                                        RegExp(r'[a-zA-Z ]'),
                                        allow: true)
                                  ],
                                  controller: lastNameController,
                                  decoration: InputDecoration(
                                    hintText: AppText.hintLastName,
                                    hintStyle: TextStyle(color: AppColors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.03),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.lightBlack,
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 3, bottom: 3),
                                      child: DropdownButton<String>(
                                        // Initial Value
                                        value: gender,
                                        hint: Text(
                                          'Select Gender',
                                          style: TextStyle(color: AppColors.black),
                                        ),
                                        isExpanded: true,
                                        underline: SizedBox(),

                                        // Down Arrow Icon
                                        icon: const Icon(Icons.keyboard_arrow_down),

                                        // Array list of items
                                        items: genderList.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? newValue) {
                                          print(newValue);
                                          setState(() {
                                            gender = newValue!;
                                          });
                                        },
                                      ),
                                    )),
                                SizedBox(height: screenSize.height * 0.03),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.lightBlack,
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 3, bottom: 3),
                                      child: DropdownButton<String>(
                                        // Initial Value
                                        value: selectedCaste,
                                        hint: Text(
                                          'Select Caste',
                                          style: TextStyle(color: AppColors.black),
                                        ),
                                        isExpanded: true,
                                        underline: SizedBox(),

                                        // Down Arrow Icon
                                        icon: const Icon(Icons.keyboard_arrow_down),

                                        // Array list of items
                                        items: casteList.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? newValue) {
                                          print(newValue);
                                          setState(() {
                                            selectedCaste = newValue!;
                                          });
                                        },
                                      ),
                                    )),
                                SizedBox(height: screenSize.height * 0.03),
                                TextField(
                                  keyboardType: TextInputType.text,
                                  controller: professionController,
                                  decoration: InputDecoration(
                                    hintText: AppText.hintProfession,
                                    hintStyle: TextStyle(color: AppColors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.03),
                                TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: AppText.hintEmail,
                                    hintStyle: TextStyle(color: AppColors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.03),
                                TextField(
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: AppText.hintPassword,
                                    hintStyle: TextStyle(color: AppColors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.03),
                                TextField(
                                  keyboardType: TextInputType.phone,
                                  controller: phoneController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    hintText: AppText.hintPhone,
                                    hintStyle: TextStyle(color: AppColors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: AppColors.lightBlack),
                                        borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.03),
                                InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    datePicker(context);
                                  },
                                  child: Container(
                                      width:
                                          MediaQuery.of(context).size.width * 0.8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.accentColor,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Ionicons.calendar_outline,
                                              color: AppColors.primaryColor,
                                            ),
                                            const Spacer(),
                                            Text(
                                              selectedDate != null
                                                  ? selectedDate
                                                  : AppText.chooseDate,
                                              style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontWeight:
                                                      AppTextWeight.boldWeight,
                                                  fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      Sizes.SMALL),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      )),
                                ),
                                SizedBox(height: screenSize.height * 0.015),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                          AppColors.primaryColor,
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20)))),
                                    onPressed: () {
                                      if (profileImage.path == '') {
                                        showMessage('Please Add Image');
                                      } else if (firstNameController.text.isEmpty) {
                                        showMessage('Please Enter First Name');
                                      } else if (lastNameController.text.isEmpty) {
                                        showMessage('Please Enter Last Name');
                                      } else if (gender == null) {
                                        showMessage('Please Select Gender');
                                      } else if (selectedCaste == null ||
                                          selectedCaste == 'Select Caste') {
                                        showMessage('Please Select Caste');
                                      } else if (professionController
                                          .text.isEmpty) {
                                        showMessage('Please Enter Profession');
                                      } else if (emailController.text.isEmpty) {
                                        showMessage('Please Enter Email');
                                      } else if (passwordController.text.isEmpty) {
                                        showMessage('Please Enter Password');
                                      } else if (passwordController.text.length <
                                          4) {
                                        showMessage(
                                            'Password should be 5 characters long');
                                      } else if (phoneController.text.isEmpty) {
                                        showMessage('Please Enter Phone Number');
                                      } else if (selectedDate == null) {
                                        showMessage('Please Enter Date Of Birth');
                                      } else {
                                        checkDuplicate();
                                      }
                                    },

                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        AppText.confirmText,
                                        style: TextStyle(
                                            color: AppColors.secondryColor,
                                            fontSize:
                                                MediaQuery.of(context).size.height *
                                                    Sizes.MEDIUM),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))),
        ],
      ),
    );
  }

  datePicker(BuildContext ctx) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        builder: (ctx) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(AppText.birthday)),
            CalendarDatePicker2(
              config: config,
              initialValue: _singleDatePickerValueWithDefaultValue,
              onValueChanged: (values) => setState(() {
                _singleDatePickerValueWithDefaultValue = values;
                print(DateFormat('yyyy-MM-dd')
                    .format(_singleDatePickerValueWithDefaultValue[0]!));
                selectedDate = DateFormat('yyyy-MM-dd')
                    .format(_singleDatePickerValueWithDefaultValue[0]!);
                Future.delayed(new Duration(milliseconds: 300), () {
                  Navigator.pop(ctx);
                });
              }),
            )
          ]);
        });
  }

  var config = CalendarDatePicker2Config(
    selectedDayHighlightColor: AppColors.primaryColor,
    weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    controlsHeight: 50,
    controlsTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
    dayTextStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
    ),
    disabledDayTextStyle: const TextStyle(
      color: Colors.grey,
    ),
  );

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  checkDuplicate() async {
    setState(() {
      isLoading = true;
    });
    Map d = {'email': emailController.text, 'phone': phoneController.text};

    var response =
        await http.post(Uri.parse(ApiConstants.DUPLICATE_CHECK), body: d);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      print(response.body);
      if (response.body == 'email_exist') {
        Fluttertoast.showToast(
            msg: "Email Already Exist",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.body == 'phone_exist') {
        Fluttertoast.showToast(
            msg: "Phone No. Already Exist",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        final bytes = File(profileImage.path).readAsBytesSync();

        String img64 = base64Encode(bytes);

        Get.to(() => BandStatusScreen(
              dob: selectedDate,
              email: emailController.text.trim().toString(),
              password: passwordController.text.trim().toString(),
              firstname: firstNameController.text.trim().toString(),
              lastname: lastNameController.text.trim().toString(),
              phone: phoneController.text.trim(),
              profession: professionController.text.toString(),
              profile: img64,
              caste: selectedCaste,
              gender: gender,
            ));
      }
    }
  }

  getCaste() async {
    var casteJson = null;
    var res = await http.get(Uri.parse(ApiConstants.GET_CASTE));
    print("${ApiConstants.GET_CASTE}///////${res.statusCode}///");
    if (res.statusCode == 200) {
      if (res.body == 'empty') {
        print('getcaste section is empty///////' '''''' '');
      } else {
        casteJson = json.decode(res.body);
        for (var a in casteJson['data']) {
          setState(() {
            casteList.add(a['name']);
          });
        }
        print('${casteList}/////////castelistt');
      }
    }
  }

  showMessage(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
