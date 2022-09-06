import 'dart:core';

import 'package:band_baaja/constants/app_data.dart';
import 'package:band_baaja/screens/SignIn.dart';
import 'package:band_baaja/screens/SignUp.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class IntroData {
  var image;
  var title;
  var description;

  IntroData({this.image, this.title, this.description});
}

class _IntroScreenState extends State<IntroScreen> {
  List<IntroData> introList = [];
  var current = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    introList.add(IntroData(
        image: AppText.algorithmImage,
        title: AppText.algorithm,
        description: AppText.algorithmDetail));
    introList.add(IntroData(
        image: AppText.matchesImage,
        title: AppText.matches,
        description: AppText.matchesDetail));
    introList.add(IntroData(
        image: AppText.premiumImage,
        title: AppText.preminum,
        description: AppText.preminumDetail));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.only(top: 10),
              child: CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 0.7,
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                    autoPlay: false,
                    viewportFraction: 1.0,
                    onPageChanged: (i, _) {
                      setState(() {
                        current = i;
                        print(current);
                      });
                    }),
                items: imageSliders,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: introList.map(
              (image) {
                int index = introList.indexOf(image);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current == index
                          ? AppColors.primaryColor
                          : AppColors.lightBlack),
                );
              },
            ).toList(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
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
                Get.to(() => SignUp());
              },

              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  AppText.createAccount,
                  style: TextStyle(
                      color: AppColors.secondryColor,
                      fontSize:
                          MediaQuery.of(context).size.height * Sizes.MEDIUM),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppText.alreadyAccount,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * Sizes.SMALL),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => SignIn());
                },
                child: Text(AppText.signin,
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.height * Sizes.SMALL,
                        color: AppColors.primaryColor,
                        fontWeight: AppTextWeight.boldWeight)),
              )
            ],
          )
        ],
      )),
    );
  }

  late List<Widget> imageSliders = introList
      .map((item) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        item.image,
                        fit: BoxFit.fitHeight,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.45,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  item.title,
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.height * Sizes.EXTRALARGE,
                      color: AppColors.primaryColor,
                      fontWeight: AppTextWeight.boldWeight),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  item.description,
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.height * Sizes.MEDIUM),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ))
      .toList();
}
