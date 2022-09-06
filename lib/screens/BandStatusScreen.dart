import 'package:band_baaja/screens/AboutScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';


import '../constants/app_data.dart';

class BandStatusScreen extends StatefulWidget {
  var profile;
  var firstname;
  var lastname;
  var profession;
  var email;
  var password;
  var phone;
  var dob;
  var caste;
  var gender;

  BandStatusScreen(
      {this.firstname, this.lastname, this.email, this.password, this.profession, this.phone, this.dob, this.profile, this.caste, this.gender});

  @override
  State<BandStatusScreen> createState() => _BandStatusScreenState();
}

class _BandStatusScreenState extends State<BandStatusScreen> {
  var withOutBandStatus;
  var bandStatus;



  //var selectedQualificationBand;

  //var selectedNonEducated;
  var qualificationBandList = [
    'Band 5.5',
    'Band 6.0',
    'Band 6.5',
    'Band 7.0',
    'Band 7.5',
    'Band 8.0',
    'Band 9.0'
  ];

  //var nonEducatedList=['Beautician', 'Taylor','Designer','Master'];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: HexColor('#fafafa'),
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: screenSize.height * 0.02,
                left: screenSize.width * 0.07,
                right: screenSize.width * 0.07,
                bottom: screenSize.height * 0.02),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.height * 0.01),
                          child: Icon(
                            Icons.arrow_back, color: AppColors.primaryColor,),
                        )),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  Text(AppText.selectOne, textAlign: TextAlign.start,
                    style: TextStyle(color: AppColors.black,
                        fontWeight: AppTextWeight.boldWeight,
                        fontSize: MediaQuery
                            .of(context)
                            .size
                            .height * Sizes.LARGE),),
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
                         // isDense: true,
                          focusColor: Colors.transparent,
                          // Initial Value
                          value: bandStatus,
                          hint: Text(
                            'Select Your Band',
                            style: TextStyle(color: AppColors.black),
                          ),
                          isExpanded: true,
                          underline: SizedBox(),

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: qualificationBandList.map((String items) {
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
                              bandStatus = newValue!;
                              withOutBandStatus = '';
                            });
                          },
                        ),
                      )),
                  // SizedBox(height: screenSize.height * 0.03),
                  // Container(
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: AppColors.lightBlack,
                  //         style: BorderStyle.solid,
                  //         width: 1.0,
                  //       ),
                  //       color: Colors.transparent,
                  //       borderRadius: BorderRadius.circular(15.0),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(
                  //           left: 10, right: 10, top: 3, bottom: 3),
                  //       child: DropdownButton<String>(
                  //         // Initial Value
                  //         value: selectedNonEducated,
                  //         hint: Text(
                  //           'Select Qualification',
                  //           style: TextStyle(color: AppColors.black),
                  //         ),
                  //         isExpanded: true,
                  //         underline: SizedBox(),
                  //
                  //         // Down Arrow Icon
                  //         icon: const Icon(Icons.keyboard_arrow_down),
                  //
                  //         // Array list of items
                  //         items: nonEducatedList.map((String items) {
                  //           return DropdownMenuItem(
                  //             value: items,
                  //             child: Text(items),
                  //           );
                  //         }).toList(),
                  //         // After selecting the desired option,it will
                  //         // change button value to selected value
                  //         onChanged: (String? newValue) {
                  //           print(newValue);
                  //           setState(() {
                  //             selectedNonEducated = newValue!;
                  //           });
                  //         },
                  //       ),
                  //     )),


                  SizedBox(height: screenSize.height * 0.03),
                  Center(child: InkWell(
                    onTap: () {
                      setState(() {
                        withOutBandStatus = 'Boy WithOut Band';
                        bandStatus = null;
                        // print(offer);
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.accentColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(AppText.boyBand, style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: AppTextWeight.boldWeight,
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .height * Sizes.SMALL),),
                              const Spacer(),
                              Icon(Icons.check,
                                color: withOutBandStatus == 'Boy WithOut Band'
                                    ? AppColors.primaryColor
                                    : AppColors.lightBlack,)
                            ],
                          ),
                        )

                    ),
                  ),),
                  SizedBox(height: screenSize.height * 0.03),
                  Center(child: InkWell(
                    onTap: () {
                      setState(() {
                        withOutBandStatus = 'Girl WithOut Band';
                        bandStatus = null;
                        // print(offer);
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.accentColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(AppText.girlBand, style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: AppTextWeight.boldWeight,
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .height * Sizes.SMALL),),
                              const Spacer(),
                              Icon(Icons.check,
                                color: withOutBandStatus == 'Girl WithOut Band'
                                    ? AppColors.primaryColor
                                    : AppColors.lightBlack,)
                            ],
                          ),
                        )

                    ),
                  ),),
                  SizedBox(height: screenSize.height * 0.03),
                  Center(child: InkWell(
                    onTap: () {
                      setState(() {
                        withOutBandStatus = 'PR Wale';
                        bandStatus = null;
                        //print(offer);

                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.accentColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(AppText.prWale, style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: AppTextWeight.boldWeight,
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .height * Sizes.SMALL),),
                              Spacer(),
                              Icon(Icons.check,
                                color: withOutBandStatus == 'PR Wale' ? AppColors
                                    .primaryColor : AppColors.lightBlack,)
                            ],
                          ),
                        )

                    ),
                  ),),
                  SizedBox(height: screenSize.height * 0.03),
                  Center(child: InkWell(
                    onTap: () {
                      setState(() {
                        withOutBandStatus = 'Offer';
                        bandStatus = null;
                        // print(offer);
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.accentColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(AppText.offer, style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: AppTextWeight.boldWeight,
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .height * Sizes.SMALL),),
                              const Spacer(),
                              Icon(Icons.check,
                                color: withOutBandStatus == 'Offer' ? AppColors
                                    .primaryColor : AppColors.lightBlack,)
                            ],
                          ),
                        )

                    ),
                  ),),
                  const Spacer(),
                  Container(width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,

                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.primaryColor,
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      if (bandStatus == null && withOutBandStatus == null) {
                        Fluttertoast.showToast(
                            msg: 'Please Select one of these',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: AppColors.primaryColor,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                      else {
                        print('Data is set $bandStatus and bandwithout is  = $withOutBandStatus');
                        Get.to(() =>
                            AboutScreen(
                                profile: widget.profile,
                                profession: widget.profession,
                                phone: widget.phone,
                                lastname: widget.lastname,
                                firstname: widget.firstname,
                                email: widget.email,
                                dob: widget.dob,
                                gender: widget.gender,
                                password: widget.password,
                                caste: widget.caste,
                              userBand: bandStatus ?? withOutBandStatus,

                              )
                            );
                        }

                        },

                    child: Padding(padding: EdgeInsets.all(20),

                      child: Text(AppText.confirmText, style: TextStyle(
                          color: AppColors.secondryColor, fontSize: MediaQuery
                          .of(context)
                          .size
                          .height * Sizes.MEDIUM),),),
                  ),),

                ]),
          )
      ),
    );
  }
}
