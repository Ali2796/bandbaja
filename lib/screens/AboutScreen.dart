import 'package:band_baaja/constants/ApiContants.dart';
import 'package:band_baaja/screens/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';


import '../constants/app_data.dart';
import 'package:http/http.dart' as http;

class AboutScreen extends StatefulWidget {
  var profile;
  var firstname;
  var lastname;
  var profession;
  var email;
  var password;
  var phone;
  var dob;
  var gender;
  var caste;
  var userBand;

  AboutScreen(
      {Key? key, this.profile,
      this.dob,
      this.phone,
      this.password,
      this.profession,
      this.email,
      this.lastname,
      this.firstname,
      this.gender,
      this.caste,
      this.userBand
      }) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late TextEditingController aboutController;
  var isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    aboutController = TextEditingController();
  }

  @override
  void dispose() {
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: HexColor('#fafafa'),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(
            top: screenSize.height * 0.02,
            left: screenSize.width * 0.07,
            right: screenSize.width * 0.07,
            bottom: screenSize.height * 0.02),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
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
                          Icons.arrow_back,
                          color: AppColors.primaryColor,
                        ),
                      )),
                ),
                SizedBox(height: screenSize.height * 0.03),
                Text(
                  AppText.about,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppColors.black,
                      fontWeight: AppTextWeight.boldWeight,
                      fontSize: MediaQuery.of(context).size.height *
                          Sizes.LARGE),
                ),
                SizedBox(height: screenSize.height * 0.03),
          SizedBox(
            height: 250,
            child: TextField(
              controller: aboutController,
              maxLines: 5 ,
               maxLength: 500,
              autofocus: true,
              // expands: true,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: AppText.hintAbout,
                contentPadding: const EdgeInsets.all(10),

                // hintText: AppText.hintAbout,

                hintStyle: TextStyle(color: AppColors.black),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 1, color: AppColors.lightBlack),
                    borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 1, color: AppColors.lightBlack),
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
                // Center(
                //   child: InkWell(
                //     onTap: () {
                //       setState(() {
                //         gender = 'male';
                //         print(gender);
                //       });
                //     },
                //     child: Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(20),
                //           color: AppColors.accentColor,
                //         ),
                //         child: Padding(
                //           padding: EdgeInsets.all(15.0),
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Text(
                //                 AppText.male,
                //                 style: TextStyle(
                //                     color: AppColors.primaryColor,
                //                     fontWeight: AppTextWeight.boldWeight,
                //                     fontSize:
                //                         MediaQuery.of(context).size.height *
                //                             Sizes.SMALL),
                //               ),
                //               Spacer(),
                //               Icon(
                //                 Icons.check,
                //                 color: gender == 'male'
                //                     ? AppColors.primaryColor
                //                     : AppColors.lightBlack,
                //               )
                //             ],
                //           ),
                //         )),
                //   ),
                // ),
                // SizedBox(height: screenSize.height * 0.01),
                // Center(
                //   child: InkWell(
                //     onTap: () {
                //       setState(() {
                //         gender = 'female';
                //         print(gender);
                //       });
                //     },
                //     child: Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(20),
                //           color: AppColors.accentColor,
                //         ),
                //         child: Padding(
                //           padding: EdgeInsets.all(15.0),
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Text(
                //                 AppText.female,
                //                 style: TextStyle(
                //                     color: AppColors.primaryColor,
                //                     fontWeight: AppTextWeight.boldWeight,
                //                     fontSize:
                //                         MediaQuery.of(context).size.height *
                //                             Sizes.SMALL),
                //               ),
                //               Spacer(),
                //               Icon(
                //                 Icons.check,
                //                 color: gender == 'female'
                //                     ? AppColors.primaryColor
                //                     : AppColors.lightBlack,
                //               )
                //             ],
                //           ),
                //         )),
                //   ),
                // ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),
                  child:
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.primaryColor,
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)))),

                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (aboutController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please Describe about yourself',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: AppColors.primaryColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        registerUser();
                      }
//                     Get.to(()=>Dashboard());
                    },
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        AppText.confirmText,
                        style: TextStyle(
                            color: AppColors.secondryColor,
                            fontSize: MediaQuery.of(context).size.height *
                                Sizes.MEDIUM),
                      ),
                    ),
                  ),
                ),
              ]),
      )),
    );
  }

  registerUser() async {
    setState(() {
      isLoading = true;
    });
    Map d = {
      'firstName': widget.firstname,
      'lastName': widget.lastname,
      'caste': widget.caste,
      'profession': widget.profession,
      'email': widget.email,
      'phone': widget.phone,
      'dob': widget.dob,
      'image': widget.profile,
      'gender': widget.gender,
      'looking_for': widget.userBand,
      'about':aboutController.text,
      'password': widget.password
    };
    var response = await http.post(Uri.parse(ApiConstants.SIGNUP), body: d);

    if (response.statusCode == 200) {
      if (response.body == 'success') {
        setState(() {
          isLoading = false;
        });
        Get.to(() => SignIn(
              email: widget.email,
              password: widget.password,
            ));
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Registration Failed. Try Again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
//    print(response.body);
    }
  }
}
