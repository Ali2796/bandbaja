import 'package:band_baaja/constants/app_data.dart';
import 'package:band_baaja/screens/IntroScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Future.delayed(new Duration(seconds: 2),(){
    Get.offAll(()=>IntroScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Text('Hello',style: TextStyle(fontSize: MediaQuery.of(context).size.height * Sizes.LARGE,color: AppColors.primaryColor,fontWeight: AppTextWeight.largeWeight),),),
      ),
    );
  }
}
