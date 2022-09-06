// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hexcolor/hexcolor.dart';
//
// import '../constants/app_data.dart';
//
// class AboutAndLocationDetails extends StatefulWidget {
//   var profile;
//   var firstname;
//   var lastname;
//   var profession;
//   var email;
//   var password;
//   var phone;
//   var dob;
//   var gender;
//   var caste;
//   var userBand;
//    AboutAndLocationDetails({this.profile,
//     this.dob,
//     this.phone,
//     this.password,
//     this.profession,
//     this.email,
//     this.lastname,
//     this.firstname,
//     this.gender,
//     this.caste,
//      this.userBand
//
//    });
//
//   @override
//   State<AboutAndLocationDetails> createState() =>
//       _AboutAndLocationDetailsState();
// }
//
// class _AboutAndLocationDetailsState extends State<AboutAndLocationDetails> {
//   late TextEditingController aboutController;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     aboutController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     aboutController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: HexColor('#fafafa'),
//       body: SafeArea(
//           child: Padding(
//         padding: EdgeInsets.only(
//             top: screenSize.height * 0.02,
//             left: screenSize.width * 0.07,
//             right: screenSize.width * 0.07,
//             bottom: screenSize.height * 0.02),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           InkWell(
//             onTap: () {
//               Get.back();
//             },
//             child: Card(
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.white70, width: 1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(screenSize.height * 0.01),
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: AppColors.primaryColor,
//                   ),
//                 )),
//           ),
//           SizedBox(height: screenSize.height * 0.03),
//           Text(
//             AppText.about,
//             textAlign: TextAlign.start,
//             style: TextStyle(
//                 color: AppColors.black,
//                 fontWeight: AppTextWeight.boldWeight,
//                 fontSize:
//                     MediaQuery.of(context).size.height * Sizes.LARGE),
//           ),
//           SizedBox(height: screenSize.height * 0.03),
//           SizedBox(
//             height: 250,
//             child: TextField(
//               controller: aboutController,
//               maxLines: 5 ,
//              // minLines: 1,
//              // maxLength: 500,
//               autofocus: true,
//               // expands: true,
//
//               keyboardType: TextInputType.multiline,
//               decoration: InputDecoration(
//                labelText: AppText.hintAbout,
//                contentPadding: const EdgeInsets.all(10),
//
//                // hintText: AppText.hintAbout,
//
//                 hintStyle: TextStyle(color: AppColors.black),
//                 enabledBorder: OutlineInputBorder(
//                     borderSide:
//                         BorderSide(width: 1, color: AppColors.lightBlack),
//                     borderRadius: BorderRadius.circular(15)),
//                 focusedBorder: OutlineInputBorder(
//                     borderSide:
//                         BorderSide(width: 1, color: AppColors.lightBlack),
//                     borderRadius: BorderRadius.circular(15)),
//               ),
//             ),
//           ),
//           const Spacer(),
//           Container(width: MediaQuery
//               .of(context)
//               .size
//               .width * 0.8, child: RaisedButton(
//             color: AppColors.primaryColor,
//             onPressed: () {
//               if (aboutController == null) {
//                 Fluttertoast.showToast(
//                     msg: 'Please Select Gender',
//                     toastLength: Toast.LENGTH_LONG,
//                     gravity: ToastGravity.BOTTOM,
//                     timeInSecForIosWeb: 1,
//                     backgroundColor: AppColors.primaryColor,
//                     textColor: Colors.white,
//                     fontSize: 16.0
//                 );
//               }
//               else {
//                 Get.to(() =>
//                     AboutAndLocationDetails(
//                       profile: widget.profile,
//                       profession: widget.profession,
//                       phone: widget.phone,
//                       lastname: widget.lastname,
//                       firstname: widget.firstname,
//                       email: widget.email,
//                       dob: widget.dob,
//                     //  gender: withOutBand,
//                       password: widget.password,
//                       caste: widget.caste,
//                     )
//                 );
//               }
//
//             },
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20)),
//             child: Padding(padding: EdgeInsets.all(20),
//
//               child: Text(AppText.confirmText, style: TextStyle(
//                   color: AppColors.secondryColor, fontSize: MediaQuery
//                   .of(context)
//                   .size
//                   .height * Sizes.MEDIUM),),),
//           ),),
//         ]),
//       )),
//     );
//   }
// }
