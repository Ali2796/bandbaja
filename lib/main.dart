import 'package:band_baaja/screens/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/IntroScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StatefulWidget homePage;
  SharedPreferences sp = await SharedPreferences.getInstance();

  if (sp.getString('id') != null) {



    homePage = const Dashboard();
  } else {
    homePage =   IntroScreen();

  }

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: homePage,
  ));
}
