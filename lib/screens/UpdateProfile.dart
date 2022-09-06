import 'dart:convert';
import 'dart:io';

import 'package:band_baaja/constants/ApiContants.dart';
import 'package:band_baaja/screens/Dashboard.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/ProfileModel.dart';
import '../constants/app_data.dart';
import 'package:http/http.dart' as http;

import 'SignIn.dart';

class UpdateProfile extends StatefulWidget {
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  File profileImage = new File('');
  File coverImage = new File('');
  File galleryOneImage = new File('');
  File galleryTwoImage = new File('');
  File galleryThreeImage = new File('');
  File galleryFourImage = new File('');
  File galleryFiveImage = new File('');

  TextEditingController addressController = new TextEditingController();
  TextEditingController aboutController = new TextEditingController();
  TextEditingController customInterestController = new TextEditingController();

  var user;
  late SharedPreferences sp;
  List<ProfileModel> pmodel =  [];
  var isLoading = false;

  List<String> tags = [];
  List<String> options = [
    'News', 'Entertainment', 'Politics',
    'Automotive', 'Sports', 'Education',
    'Fashion', 'Travel', 'Food', 'Tech',
    'Science',
  ];

  var cover;
  var profile;
  var gOne;
  var gTwo;
  var gThree;
  var gFour;
  var gFive;
  var gSix;
  var uInterest;
  
  getProfileData() async {
    var jsonData = null;


    sp = await SharedPreferences.getInstance();
    var a = sp.getString('id');
    setState(() {
      user = a;
    isLoading = true;
    });
    Map d = {
      'id': user
    };
    var response = await http.post(
        Uri.parse(ApiConstants.GET_USER_PROFILE), body: d);

    if (response.statusCode == 200) {
      print(response.body);
      if (response.body == 'error') {

      }
      else {
        setState(() {
          jsonData = json.decode(response.body);
          for(var a in jsonData['profile']){
            pmodel.add(ProfileModel(
                id: a['id'],
                firstname: a['first_name'],
                lastname: a['last_name'],
                profession: a['profession'],
                email: a['email'],
                address: a['address'] ?? ' ',
                about: a['about'] ?? ' ',
                cover: a['cover_image'],
                dob: Jiffy(a['dob'], "yyyy-MM-dd").fromNow().substring(0,2),
                gender: a['gender'],
                bandStatus: a['userBand'],
                interest: a['interest'],
                phone: a['phone'],
                profile: a['profile_image'],
                galleryOne: a['gallery_one'],
                galleryTwo: a['gallery_two'],
                galleryThree: a['gallery_three'],
                galleryFour: a['gallery_four'],
                galleryFive: a['gallery_five']
            ));
          }

          isLoading = false;
          var conve = pmodel[0].interest.toString().substring(1,pmodel[0].interest.toString().length-1);
          var splitag = conve.split(",");
          setState(() {
            addressController.text = pmodel[0].address ?? '';
            aboutController.text = pmodel[0].about ?? '';
          });
          for(var a in splitag){
            setState(() {
              tags.add(a.trim());
            });
            print('$a///////////////////a in list');
          }
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;
    return Container(
      height: screenSize.height * 0.88,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 5),
        child: isLoading   ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),)
        : pmodel.length > 0 ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(
              height: screenSize.height * 0.2,
              width: screenSize.width * 1,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        _getFromGallery('cover');
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: pmodel[0].cover != null && coverImage.path == '' ?
                        Image.network(ApiConstants.BASE+pmodel[0].cover,fit: BoxFit.cover,)
                            :
                        coverImage.path == '' ? Image.network(

                          ApiConstants.NO_IMAGE, fit: BoxFit.fitHeight,
                          width: screenSize.width,)
                            : Image.file(coverImage, fit: BoxFit.cover,
                          width: screenSize.width,),
                      )
                  ),
                  Positioned(
                      top: 0,
                      left: -15,
                      child: RawMaterialButton(
                        onPressed: () {
                          Get.offAll(() => const Dashboard());
                        },
                        elevation: 2.0,
                        fillColor: AppColors.lightBlack,
                        child: Icon(Icons.arrow_back, color: Colors.white,
                            size: screenSize.height * 0.03),
                        padding: const EdgeInsets.all(1.5),
                        shape: const CircleBorder(
                            side: BorderSide(
                                color: Colors.white,
                                width: 2
                            )),
                      )),
                  Positioned(
                      top: 0,
                      right: -10,
                      child: RawMaterialButton(
                        onPressed: () async{
                          SharedPreferences sp = await SharedPreferences.getInstance();
                          sp.clear();
                          Get.offAll(()=>SignIn());
                        },
                        elevation: 2.0,
                        fillColor: AppColors.lightBlack,
                        child: Icon(Icons.logout, color: Colors.white,
                            size: screenSize.height * 0.025),
                        padding: const EdgeInsets.all(8.5),
                        shape: const CircleBorder(
                            side: BorderSide(
                                color: Colors.white,
                                width: 2
                            )),
                      )),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 10),
              child: Center(child: SizedBox(

                height: screenSize.height * 0.11,
                width: screenSize.width * 0.225,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: pmodel[0].profile != null && profileImage.path.isEmpty ?
                      Image.network(ApiConstants.BASE+pmodel[0].profile,fit: BoxFit.cover,)
                      :
                      profileImage.path == '' ? Image.network(

                        ApiConstants.NO_IMAGE, fit: BoxFit.fitHeight,) :
                      Image.file(profileImage, fit: BoxFit.cover,),

                    ),
                    Positioned(
                        bottom: -10,
                        right: -40,
                        child: RawMaterialButton(
                          onPressed: () {
                            _getFromGallery('profile');
                          },
                          elevation: 2.0,
                          fillColor: AppColors.primaryColor,
                          child: Icon(Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: screenSize.height * 0.02),
                          padding: const EdgeInsets.all(1.0),
                          shape: const CircleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 2
                              )),
                        )),
                  ],
                ),
              )
              ),
            ),
            Padding(padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pmodel[0].firstname+', '+pmodel[0].dob, textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: screenSize.height * Sizes.LARGE,
                          color: AppColors.black,
                          fontWeight: AppTextWeight.boldWeight),),
                    const SizedBox(height: 4,),
                    Text(pmodel[0].profession, style: TextStyle(
                        fontSize: screenSize.height * Sizes.MEDIUM,
                        color: AppColors.black,
                        fontWeight: AppTextWeight.normalWeight),),
                    SizedBox(height: screenSize.height * 0.02,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Band Status', style: TextStyle(
                            color: AppColors.black,
                            fontSize: screenSize.height * Sizes.MEDIUM,
                            fontWeight: AppTextWeight.boldWeight),),
                        SizedBox(height: screenSize.height * 0.01,),
                        Text(pmodel[0].bandStatus ?? '', style: TextStyle(
                            fontSize: screenSize.height * Sizes.MEDIUM,
                            color: AppColors.black,
                            fontWeight: AppTextWeight.normalWeight),)
                      ],
                    ),
                    // TextField(
                    //   controller: addressController,
                    //   decoration: InputDecoration(
                    //     hintText: AppText.hintAddress,
                    //     hintStyle: TextStyle(color: AppColors.black),
                    //     enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             width: 1, color: AppColors.lightBlack),
                    //         borderRadius: BorderRadius.circular(15)
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             width: 1, color: AppColors.lightBlack),
                    //         borderRadius: BorderRadius.circular(15)
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: screenSize.height * 0.03,),
                    Column(
                     // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text('About Yourself', style: TextStyle(
                            color: AppColors.black,
                            fontSize: screenSize.height * Sizes.MEDIUM,
                            fontWeight: AppTextWeight.boldWeight),),
                        SizedBox(height: screenSize.height * 0.01,),
                        SizedBox(
                          height: 120,
                          child: TextField(
                            controller: aboutController,
                            maxLines: 5,
                           readOnly: true,

                           // minLines: 1,
                           // expands: true,

                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                             // labelText: AppText.hintAbout,
                              //hintText: AppText.hintAbout,
                              contentPadding: EdgeInsets.all(10),

                              hintStyle: TextStyle(color: AppColors.black),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppColors.lightBlack),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppColors.lightBlack),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.02,),
                    Row(
                      children: [
                        Text('Interest', style: TextStyle(
                            color: AppColors.black,
                            fontSize: screenSize.height * Sizes.MEDIUM,
                            fontWeight: AppTextWeight.boldWeight),),
                        Spacer(),
                        Container(
                            height: 30,
                            width: 30,
                            child: FloatingActionButton(onPressed: () {
                              _displayDialog(context);
                            },
                              materialTapTargetSize: MaterialTapTargetSize
                                  .padded,
                              child: Icon(Icons.add, color: Colors.white,
                                  size: 20),
                              backgroundColor: AppColors.primaryColor,)
                        ),
                        SizedBox(width: screenSize.width * 0.02,)

                      ],
                    ),

                    Container(
                        height: screenSize.height * 0.06,
                        child: Row(
                            children: [
                              Expanded(
                                  child: ListView(
                                      addAutomaticKeepAlives: true,
                                      children: [
                                        ChipsChoice<String>.multiple(
                                          value: tags,
                                          onChanged: (val) {
                                            print('$val/////////////$tags/////////');
                                            setState(() => tags = val);
                                            print('$val/////////////$tags/////////');
                                          },
                                          choiceItems: C2Choice.listFrom<
                                              String,
                                              String>(
                                            source: options.reversed.toList(),
                                            value: (i, v) => v,
                                            label: (i, v) => v,
                                          ),
                                          choiceActiveStyle: C2ChoiceStyle(
                                            color: AppColors.primaryColor,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          choiceStyle: C2ChoiceStyle(
                                            showCheckmark: false,
                                            color: Colors.white,
                                            backgroundColor: AppColors
                                                .primaryColor,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          wrapped: false,
                                        )
                                      ]
                                  )
                              )
                            ]
                        )),
                      SizedBox(height: screenSize.height * 0.01,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     Container(
                    //       child: Padding(
                    //           padding: EdgeInsets.only(top: 5,
                    //               left: screenSize.width * 0.07,
                    //               right: screenSize.width * 0.07,
                    //               bottom: 5), child:
                    //       Text(
                    //         'Traveling',
                    //         style: TextStyle(color: Colors.black,
                    //             fontSize: screenSize.height * Sizes.MEDIUM),
                    //       )),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(5),
                    //         color: Colors.white,
                    //         boxShadow: [
                    //           BoxShadow(color: Colors.black, spreadRadius: 1),
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       child: Padding(
                    //           padding: EdgeInsets.only(top: 5,
                    //               left: screenSize.width * 0.07,
                    //               right: screenSize.width * 0.07,
                    //               bottom: 5), child:
                    //       Text(
                    //         'Books',
                    //         style: TextStyle(color: Colors.black,
                    //             fontSize: screenSize.height * Sizes.MEDIUM),
                    //       )),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(5),
                    //         color: Colors.white,
                    //         boxShadow: [
                    //           BoxShadow(color: Colors.black, spreadRadius: 1),
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       child: Padding(
                    //           padding: EdgeInsets.only(top: 5,
                    //               left: screenSize.width * 0.07,
                    //               right: screenSize.width * 0.07,
                    //               bottom: 5), child:
                    //       Text(
                    //         'Music',
                    //         style: TextStyle(color: Colors.black,
                    //             fontSize: screenSize.height * Sizes.MEDIUM),
                    //       )),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(5),
                    //         color: Colors.white,
                    //         boxShadow: [
                    //           BoxShadow(color: Colors.black, spreadRadius: 1),
                    //         ],
                    //       ),
                    //     ),
                    //   ],),

//                    SizedBox(height: screenSize.height * 0.02,),

                    Text('Gallery', style: TextStyle(color: AppColors.black,
                        fontSize: screenSize.height * Sizes.MEDIUM,
                        fontWeight: AppTextWeight.boldWeight),),
                    SizedBox(height: screenSize.height * 0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              _getFromGallery('g1');
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.lightBlack,

                                ),
                                height: screenSize.height * 0.2,
                                width: screenSize.width * 0.35,
                                child: pmodel[0].galleryOne != null && galleryOneImage.path == '' ?
                                Image.network(ApiConstants.BASE+pmodel[0].galleryOne,fit: BoxFit.cover,)
                                : galleryOneImage.path == '' ? const Center(
                                    child: Icon(Icons.camera_alt_outlined))
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(
                                    galleryOneImage, fit: BoxFit.cover,),

                                )

                            )),
                        SizedBox(width: screenSize.width * 0.08,),
                        InkWell(
                            onTap: () {
                              _getFromGallery('g2');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.lightBlack,

                              ),
//                          color: AppColors.lightBlack,
                              height: screenSize.height * 0.2,
                              width: screenSize.width * 0.35,
                              child: pmodel[0].galleryTwo != null && galleryTwoImage.path == '' ?
                              Image.network(ApiConstants.BASE+pmodel[0].galleryTwo,fit: BoxFit.cover,)
                             :
                              galleryTwoImage.path == '' ? Center(
                                  child: Icon(Icons.camera_alt_outlined))
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(
                                  galleryTwoImage, fit: BoxFit.cover,),

                              )
                              ,)),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              _getFromGallery('g3');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.lightBlack,

                              ),
//                          color: AppColors.lightBlack,
                              height: screenSize.height * 0.2,
                              width: screenSize.width * 0.28,
                              child: pmodel[0].galleryThree != null && galleryThreeImage.path == '' ?
                              Image.network(ApiConstants.BASE+pmodel[0].galleryThree,fit: BoxFit.cover,)
                                  :
                              galleryThreeImage.path == '' ? Center(
                                  child: Icon(Icons.camera_alt_outlined))
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(
                                  galleryThreeImage, fit: BoxFit.cover,),

                              )
                              ,)),
                        SizedBox(width: screenSize.width * 0.03,),
                        InkWell(
                            onTap: () {
                              _getFromGallery('g4');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.lightBlack,

                              ),
//                          color: AppColors.lightBlack,
                              height: screenSize.height * 0.2,
                              width: screenSize.width * 0.28,
                              child: pmodel[0].galleryFour != null && galleryFourImage.path == '' ?
                              Image.network(ApiConstants.BASE+pmodel[0].galleryFour,fit: BoxFit.cover,)
                                  :
                              galleryFourImage.path == '' ? Center(
                                  child: Icon(Icons.camera_alt_outlined))
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(
                                  galleryFourImage, fit: BoxFit.cover,),

                              )
                              ,)),
                        SizedBox(width: screenSize.width * 0.03,),
                        InkWell(
                            onTap: () {
                              _getFromGallery('g5');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.lightBlack,

                              ),
//                          color: AppColors.lightBlack,
                              height: screenSize.height * 0.2,
                              width: screenSize.width * 0.28,
                              child:pmodel[0].galleryFive != null && galleryFiveImage.path == '' ?
                              Image.network(ApiConstants.BASE+pmodel[0].galleryFive,fit: BoxFit.cover,)
                                  :
                              galleryFiveImage.path == '' ? Center(
                                  child: Icon(Icons.camera_alt_outlined))
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(
                                  galleryFiveImage, fit: BoxFit.cover,),

                              )
                              ,)),

                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.01,),
                    Container(child: Container(width: MediaQuery
                        .of(context)
                        .size
                        .width * 1,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primaryColor,
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                      onPressed: () {
                        updateRequest();
                      },

                      child: Padding(padding: EdgeInsets.all(20),

                        child: Text('Save', style: TextStyle(
                            color: AppColors.secondryColor, fontSize: MediaQuery
                            .of(context)
                            .size
                            .height * Sizes.MEDIUM),),),
                    ),)
                    ),
                  ],

                )
            )
          ],
        ) : SizedBox(height: 0,),
      ),
    );
  }

  _getFromGallery(type) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 20
    );
    if (pickedFile != null) {
      setState(() {
        if (type == 'profile') {
          profileImage = File(pickedFile.path);
        }
        if (type == 'cover') {
          coverImage = File(pickedFile.path);
        }
        if (type == 'g1') {
          galleryOneImage = File(pickedFile.path);
        }
        if (type == 'g2') {
          galleryTwoImage = File(pickedFile.path);
        }
        if (type == 'g3') {
          galleryThreeImage = File(pickedFile.path);
        }
        if (type == 'g4') {
          galleryFourImage = File(pickedFile.path);
        }
        if (type == 'g5') {
          galleryFiveImage = File(pickedFile.path);
        }


        // profileImage = File(pickedFile.path);
      });
    }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Custom Interest'),
            content: TextField(
              controller: customInterestController,
              decoration: InputDecoration(hintText: "Enter Text"),
            ),
            actions: [
              new ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.primaryColor,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                child: new Text('Save'),
                onPressed: () {
                  setState(() {
                    options.add(customInterestController.text);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
  
  
  updateRequest() async{
    setState(() {
      isLoading = true;
    });
    if(profileImage.path.isNotEmpty){
      final bytesp = File(profileImage.path).readAsBytesSync();

      String profile64 = base64Encode(bytesp);
        setState(() {
          profile = profile64;
        });
    }
    else{
      setState(() {
        profile = pmodel[0].profile;
      });
    }
    if(coverImage.path.isNotEmpty){
      print('cover if');
      final bytesc = File(coverImage.path).readAsBytesSync();

      String cover64 = base64Encode(bytesc);
      print('cover image address is  = $cover64');
      setState(() {
        cover = cover64;
        print('$cover//////////////cover ////////and $coverImage');
      });
    }
    else{
      cover = pmodel[0].cover;
    }
    if(galleryOneImage.path.isNotEmpty){
      final bytesgon = File(galleryOneImage.path).readAsBytesSync();

      String gone64 = base64Encode(bytesgon);
      setState(() {
        gOne = gone64;
      });
    }
    else{
      gOne = pmodel[0].galleryOne;
    }

    if(galleryTwoImage.path.isNotEmpty){
      final bytesgtw = File(galleryTwoImage.path).readAsBytesSync();

      String gtwo64 = base64Encode(bytesgtw);
      setState(() {
        gTwo = gtwo64;
      });
    }
    else{
      gTwo = pmodel[0].galleryTwo;
    }
    if(galleryThreeImage.path.isNotEmpty){
      final bytesgth = File(galleryThreeImage.path).readAsBytesSync();

      String gthree64 = base64Encode(bytesgth);
      setState(() {
        gThree = gthree64;
      });
    }
    else{
      gThree = pmodel[0].galleryThree;
    }
    if(galleryFourImage.path.isNotEmpty){
      final bytesgfo = File(galleryFourImage.path).readAsBytesSync();

      String gfour64 = base64Encode(bytesgfo);
      setState(() {
        gFour = gfour64;
      });
    }
    else{
      gFour = pmodel[0].galleryFour;
    }
    if(galleryFiveImage.path.isNotEmpty){
      final bytesgfi = File(galleryFiveImage.path).readAsBytesSync();

      String gfive64 = base64Encode(bytesgfi);
      setState(() {
        gFive = gfive64;
      });
    }
    else{
      gFive= pmodel[0].galleryFive;
    }

    Map d ={
    'profile':profile,
      'cover':cover,
      'galleryOne':gOne,
      'galleryTwo':gTwo,
      'galleryThree':gThree,
      'galleryFour':gFour,
      'galleryfive':gFive,
      'interest':tags.toString(),
     // 'address':addressController.text,
      'about':aboutController.text,
      'id':user
    };
    print('$cover//////////////////map of update');
    var response = await http.post(Uri.parse(ApiConstants.UPDATE_PROFILE),body: d);
    //print('$d//////////////////map of update');
    if(response.statusCode == 200){
      print('$d//////////////////map of update');
      if(response.body == 'success'){
        print('${response.body}//////////////////map of update');
        setState(() {
          isLoading = false;
          pmodel.clear();
          getProfileData();
        });
      // Navigator.pop(context);
      }
      else{
        setState(() {
          isLoading = false ;
        });
        Fluttertoast.showToast(
            msg: "Profile Update Failed. Try Again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      // print(response.body);
    }else{
      setState(() {
        isLoading = false;
      });
      print('Updates failed');
    }

  }
}
