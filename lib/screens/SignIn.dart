import 'dart:convert';

import 'package:band_baaja/constants/ApiContants.dart';
import 'package:band_baaja/constants/app_data.dart';
import 'package:band_baaja/screens/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  var email;
  var password;
  SignIn({this.email,this.password});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.email != null && widget.password !=null) {
      emailController.text = widget.email!;
      passwordController.text = widget.password!;
    }
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: HexColor('#fafafa'),
    body: SafeArea(
    child: Padding(
        padding: EdgeInsets.only(top: screenSize.height * 0.02,left: screenSize.width * 0.1,right: screenSize.width *0.1,bottom: screenSize.height * 0.05),
    child: isLoading ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),)
        : Column(
      mainAxisAlignment: MainAxisAlignment.center,
    children: [
        Text(AppText.signin,textAlign: TextAlign.center,style: TextStyle(color: AppColors.primaryColor,fontSize: screenSize.height * Sizes.LARGE,fontWeight: AppTextWeight.boldWeight),),
      SizedBox(height: screenSize.height * 0.03),

      TextField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: AppText.hintEmail,
          hintStyle: TextStyle(color: AppColors.black),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColors.lightBlack),
              borderRadius: BorderRadius.circular(15)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColors.lightBlack),
              borderRadius: BorderRadius.circular(15)
          ),
        ),
      ),
      SizedBox(height: screenSize.height * 0.03),

      TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: AppText.hintPassword,
          hintStyle: TextStyle(color: AppColors.black),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColors.lightBlack),
              borderRadius: BorderRadius.circular(15)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColors.lightBlack),
              borderRadius: BorderRadius.circular(15)
          ),
        ),
      ),

      SizedBox(height: screenSize.height * 0.020),
      Container(width: MediaQuery.of(context).size.width * 0.8,

        child:ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                AppColors.primaryColor,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
        onPressed: () {
          if(emailController.text.isEmpty){
            showMessage('Please Enter Email');
          }
          else if(passwordController.text.isEmpty){
            showMessage('Please Enter Password');
          }
          else {
            checkLogin();
          }
//      Get.offAll(()=>Dashboard());
        },

        child: Padding(padding: EdgeInsets.all(20),

          child: Text(AppText.signin,style: TextStyle(color: AppColors.secondryColor,fontSize: MediaQuery.of(context).size.height * Sizes.MEDIUM),),),
      ),),
    ]
    )
    )
    ),
      bottomNavigationBar: isLoading ? const SizedBox() : Padding(
        padding: EdgeInsets.only(bottom: screenSize.height * 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
             Text(AppText.termofuse,style: TextStyle(color: AppColors.primaryColor,fontWeight: AppTextWeight.boldWeight),),
          SizedBox(width: screenSize.width *0.1,),
          Text(AppText.privacypolicy,style: TextStyle(color: AppColors.primaryColor,fontWeight: AppTextWeight.boldWeight),),

        ]),
      ),
    );
  }
  
  checkLogin() async{
     prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });
    Map d = {
      'email':emailController.text,
      'password':passwordController.text
    };
    print(ApiConstants.SIGNIN);
    print(d);
    var response = await http.post(Uri.parse(ApiConstants.SIGNIN),body: d);
    var jsonData = null;

    if(response.statusCode == 200){
        print(response.body);
      setState(() {
        isLoading = false;
      });
      if(response.body == 'error'){
        Fluttertoast.showToast(
            msg: "Invalid Login Credentials. Try Again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      else{
      setState(() {
        jsonData = json.decode(response.body);
       print(jsonData['data']);
        for(var a in jsonData['data']) {
          print(a['status']+'status');
          if (a['status'] == '0') {
            Fluttertoast.showToast(
                msg: "Account Not Activated",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
          else {
            if(a['interest'] == null){
                   print('null');
                 }
                 else{
                   print(a['interest']+'interests');
                 }
                 prefs.setString('id', a['id']);
               prefs.setString('email', a['email']);
               prefs.setString('phone', a['phone']);
               Get.offAll(()=>const Dashboard());
          }
        }
      });
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
        fontSize: 16.0
    );
  }
}
