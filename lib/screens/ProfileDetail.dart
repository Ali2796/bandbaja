import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/ProfileModel.dart';
import '../constants/ApiContants.dart';
import '../constants/app_data.dart';
import 'ImagePreview.dart';

class ProfileDetail extends StatefulWidget {
  ProfileModel profileModel;

  ProfileDetail({Key? key, required this.profileModel}) : super(key: key);

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  List<String> profileInterests = [];
  bool isLoading = false;
  var paymentStatus = '';

  List<Map<String, dynamic>> favouriteUser = [];
  late String profileId;
  late String email;
  late String phoneNumber;
  late var _razorpay;
  var message;
  static const platform = MethodChannel('razorpay_flutter');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavourite();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    var conve = widget.profileModel.interest
        .toString()
        .substring(1, widget.profileModel.interest.toString().length - 1);
    print("$conve///////////////////////interests");
    var splitag = conve.split(",");
    print("$splitag///////////////////////interests");
    for (var a in splitag) {
      setState(() {
        profileInterests.add(a);
      });
    }
  }

  void getFavourite() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    profileId = sp.getString('id')!;
     email = sp.getString('email')!;
     phoneNumber = sp.getString('phone')!;
     setState(() {
       isLoading = true;
     });
    print(
        'Partner profile id is = ${widget.profileModel.id} and name is = ${widget.profileModel.firstname} and my id is = ${sp.getString('id')}');

    var jsonData = null;
    print(ApiConstants.GET_FEATURES +
        "?profile=" +
        "$profileId" +
        "&partnerp=" +
        "${widget.profileModel.id}");
    var response = await http.get(Uri.parse(ApiConstants.GET_FEATURES +
        "?profile=" +
        "$profileId" +
        "&partnerp=" +
        "${widget.profileModel.id}"));

    if (response.statusCode == 200) {
      print(
          'in Profile details the code is ${response.statusCode} sdfsg  and ${response.body}');
      if (response.body == 'error') {
        print('error is thrown');
        setState(() {
          isLoading = false;
        });
      } else if (response.body == 'empty') {
        setState(() {
          isLoading = false;
          paymentStatus = '0';
        });
        print('the data not found');
      } else {
        setState(() {
          jsonData = json.decode(response.body);
          print('${jsonData['data']}/////////////////////////');
          for (var a in jsonData['data']) {
            setState(() {
              paymentStatus = a['payment'];
              isLoading = false;
              favouriteUser.add(a);
            });
          }
        });
      }
      print(response.body);
    } else {
      print('Some 404 error occur');
    }
    print('total profiles = ${favouriteUser.length}//////${favouriteUser}///');
    print('the payment status is ${paymentStatus}');
  }

  void setFavourite({
    String? profileId,
    String? partnerId,
    String? favourite,
    String? payment,
  }) async {
    Map body = {
      'profile': profileId,
      'patnerp': partnerId,
      'feature': favourite,
      'payment': payment
    };

    var response = await http.post(
        Uri.parse(ApiConstants.SET_FEATURES +
            "?profile=" +
            "$profileId" +
            "&partnerp=" +
            "$partnerId" +
            "&feature=" +
            "$favourite" +
            "&payment=" +
            "$payment"),
        body: body);
    if (response.statusCode == 200) {
      if (response.body == 'success') {
        setState(() {
          paymentStatus = "1";
        });
        print('Data is posted successfully');
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed. Try Again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      print("Payment success ${response.orderId}");
      print("Payment ID ${response.paymentId}");
      message = "SUCCESS: " + response.paymentId!;
      setFavourite(
          partnerId: widget.profileModel.id,
          profileId: profileId,
          favourite: '1',
          payment: '1');

      showMessage(message);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    message = "ERROR: " +
        response.code.toString() +
        " - " +
        jsonDecode(response.message!)['error']['description'];
    setFavourite(
        partnerId: widget.profileModel.id,
        profileId: profileId,
        favourite: '0',
        payment: '0');
    showMessage(message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    message = "EXTERNAL_WALLET: " + response.walletName!;
    setFavourite(
        partnerId: widget.profileModel.id,
        profileId: profileId,
        favourite: '1',
        payment: '1');
    showMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : Container(
              height: screenSize.height,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.95,
                      width: screenSize.width * 1,
                      child: Stack(
                        clipBehavior: Clip.antiAlias,
                        fit: StackFit.loose,
                        alignment: Alignment.topCenter,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0.0),
                            child: Container(
                                height: screenSize.height * 0.5,
                                child: widget.profileModel.profile == null
                                    ? Image.asset(
                                        "assets/one.jpg",
                                        fit: BoxFit.cover,
                                        width: screenSize.width,
                                      )
                                    : Image.network(
                                        ApiConstants.BASE +
                                            widget.profileModel.profile,
                                        fit: BoxFit.cover,
                                        width: screenSize.width,
                                      )),
                          ),
                          Positioned(
                              top: 0,
                              left: -15,
                              child: RawMaterialButton(
                                onPressed: () {
                                  Get.back();
                                },
                                elevation: 2.0,
                                fillColor: Colors.black12,
                                child: Icon(Icons.arrow_back,
                                    color: Colors.white,
                                    size: screenSize.height * 0.03),
                                padding: EdgeInsets.all(1.5),
                                shape: const CircleBorder(
                                    side: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                              )),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: screenSize.height * 0.4),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 15, right: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            widget.profileModel.firstname +
                                                ', ' +
                                                widget.profileModel.dob,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: screenSize.height *
                                                        Sizes.LARGE -
                                                    2,
                                                color: AppColors.black,
                                                fontWeight:
                                                    AppTextWeight.boldWeight),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Caste : ' +
                                                widget.profileModel.caste,
                                            style: TextStyle(
                                                fontSize: screenSize.height *
                                                        Sizes.MEDIUM -
                                                    2,
                                                color: AppColors.black,
                                                fontWeight:
                                                    AppTextWeight.normalWeight),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            widget.profileModel.profession,
                                            style: TextStyle(
                                                fontSize: screenSize.height *
                                                        Sizes.MEDIUM -
                                                    2,
                                                color: AppColors.black,
                                                fontWeight:
                                                    AppTextWeight.normalWeight),
                                          ),
                                          SizedBox(
                                            height: screenSize.height * 0.03,
                                          ),
                                          // Text(
                                          //   'Address',
                                          //   textAlign: TextAlign.start,
                                          //   style: TextStyle(
                                          //       fontSize:
                                          //           screenSize.height * Sizes.LARGE -
                                          //               2,
                                          //       color: AppColors.black,
                                          //       fontWeight: AppTextWeight.boldWeight),
                                          // ),
                                          // const SizedBox(
                                          //   height: 4,
                                          // ),
                                          // Text(
                                          //   widget.profileModel.address,
                                          //   style: TextStyle(
                                          //       fontSize:
                                          //           screenSize.height * Sizes.MEDIUM -
                                          //               2,
                                          //       color: AppColors.black,
                                          //       fontWeight:
                                          //           AppTextWeight.normalWeight),
                                          // ),
                                          // SizedBox(
                                          //   height: screenSize.height * 0.03,
                                          // ),
                                          Text(
                                            'About',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: screenSize.height *
                                                        Sizes.LARGE -
                                                    2,
                                                color: AppColors.black,
                                                fontWeight:
                                                    AppTextWeight.boldWeight),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          widget.profileModel.about
                                                      .toString()
                                                      .length >
                                                  150
                                              ? ReadMoreText(
                                                  'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                                                  trimLines: 2,
                                                  colorClickableText:
                                                      Colors.pink,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText:
                                                      '\nShow more',
                                                  trimExpandedText:
                                                      '\nShow less',
                                                  moreStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .primaryColor),
                                                )
                                              : ReadMoreText(
                                                  '${widget.profileModel.about}',
                                                  trimLines: 2,
                                                  colorClickableText:
                                                      Colors.pink,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText:
                                                      '\nShow more',
                                                  trimExpandedText:
                                                      '\nShow less',
                                                  moreStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .primaryColor),
                                                ),
                                          // Text(
                                          //         widget.profileModel.about,
                                          //         style: TextStyle(
                                          //             fontSize: 14,
                                          //             fontWeight: FontWeight.bold,
                                          //             color: AppColors.primaryColor),
                                          //       ),
                                          SizedBox(
                                            height: screenSize.height * 0.03,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Phone Number',
                                                    style: TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            AppTextWeight
                                                                .boldWeight),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    paymentStatus.contains('1')
                                                        ? widget
                                                            .profileModel.phone
                                                        : '${widget.profileModel.phone.replaceAll(RegExp(r"."), "*")}',
                                                    style: TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            AppTextWeight
                                                                .normalWeight),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              // RaisedButton(
                                              //   color: AppColors.primaryColor,
                                              //   shape: RoundedRectangleBorder(
                                              //       borderRadius:
                                              //           BorderRadius.circular(5)),
                                              //   onPressed: () {
                                              //
                                              //     !isObscure ? null : showMessage('You are a premium User');
                                              //   },
                                              //   child: Row(
                                              //     children: [
                                              //       Icon(
                                              //         Ionicons.sparkles_outline,
                                              //         color: Colors.white,
                                              //         size: screenSize.height * 0.02,
                                              //       ),
                                              //       SizedBox(
                                              //         width: screenSize.width * 0.03,
                                              //       ),
                                              //        Text(
                                              //         !isObscure ? 'Get Premium' : 'Done',
                                              //         style: const TextStyle(
                                              //             color: Colors.white),
                                              //       )
                                              //     ],
                                              //   ),
                                              // )
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenSize.height * 0.04,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Email address',
                                                    style: TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            AppTextWeight
                                                                .boldWeight),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    paymentStatus.contains('1')
                                                        ? widget
                                                            .profileModel.email
                                                        : '${widget.profileModel.email.replaceAll(RegExp(r"."), "*")}',
                                                    style: TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            AppTextWeight
                                                                .normalWeight),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(
                                                      AppColors.primaryColor,
                                                    ),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20)))),
                                                onPressed: () {
                                                  paymentStatus.contains('0')
                                                      ? setState(() {
                                                          //isObscure = !isObscure;
                                                          ///Make payment
                                                          var options = {
                                                            'key':
                                                                RazorpayManager.razorPayApiKey,
                                                            // amount will be multiple of 100
                                                            'amount':
                                                                RazorpayManager.payment
                                                                    .toString(),
                                                            //So its pay 500
                                                            'name':
                                                                'Baljeet Singh',
                                                            'description':
                                                                'You are paying to Baljeet Singh',
                                                            'timeout': 300,
                                                            // in seconds
                                                            "currency": "INR",
                                                            'prefill': {
                                                              'contact':
                                                                  phoneNumber,
                                                              'email': email
                                                            }
                                                          };
                                                          try {
                                                            _razorpay
                                                                .open(options);
                                                          } catch (e) {
                                                            debugPrint(
                                                                e.toString());
                                                          }
                                                        })
                                                      : showMessage(
                                                      'You are a premium User');
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Ionicons.sparkles_outline,
                                                      color: Colors.white,
                                                      size: screenSize.height *
                                                          0.02,
                                                    ),
                                                    SizedBox(
                                                      width: screenSize.width *
                                                          0.03,
                                                    ),
                                                    Text(
                                                      paymentStatus
                                                              .contains('0')
                                                          ? 'Get Premium'
                                                          : 'Done',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenSize.height * 0.02,
                                          ),
                                          Text(
                                            'Interest',
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: screenSize.height *
                                                    Sizes.MEDIUM,
                                                fontWeight:
                                                    AppTextWeight.boldWeight),
                                          ),
                                          SizedBox(
                                            height: screenSize.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                  height:
                                                      screenSize.height * 0.05,
                                                  width: screenSize.width * 0.9,
                                                  child: ListView.builder(
                                                      itemCount:
                                                          profileInterests
                                                              .length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder: (_, i) {
                                                        return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    right: 5),
                                                            child: Chip(
                                                              backgroundColor:
                                                                  AppColors
                                                                      .primaryColor,
                                                              //CircleAvatar
                                                              label: Text(
                                                                profileInterests[
                                                                    i],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white),
                                                              ), //Text
                                                            ));
                                                      })),

                                              // Container(
                                              //   child: Padding(padding: EdgeInsets.only(top: 5,left: screenSize.width * 0.07,right: screenSize.width * 0.07,bottom: 5),child:
                                              //   Text(
                                              //     'Traveling',
                                              //     style: TextStyle(color: Colors.black,fontSize: screenSize.height * Sizes.MEDIUM),
                                              //   )),
                                              //   decoration: BoxDecoration(
                                              //     borderRadius: BorderRadius.circular(5),
                                              //     color: Colors.white,
                                              //     boxShadow: [
                                              //       BoxShadow(color: Colors.black, spreadRadius: 1),
                                              //     ],
                                              //   ),
                                              // ),
                                              // Container(
                                              //   child: Padding(padding: EdgeInsets.only(top: 5,left: screenSize.width * 0.07,right: screenSize.width * 0.07,bottom: 5),child:
                                              //   Text(
                                              //     'Books',
                                              //     style: TextStyle(color: Colors.black,fontSize: screenSize.height * Sizes.MEDIUM),
                                              //   )),
                                              //   decoration: BoxDecoration(
                                              //     borderRadius: BorderRadius.circular(5),
                                              //     color: Colors.white,
                                              //     boxShadow: [
                                              //       BoxShadow(color: Colors.black, spreadRadius: 1),
                                              //     ],
                                              //   ),
                                              // ),
                                              // Container(
                                              //   child: Padding(padding: EdgeInsets.only(top: 5,left: screenSize.width * 0.07,right: screenSize.width * 0.07,bottom: 5),child:
                                              //   Text(
                                              //     'Music',
                                              //     style: TextStyle(color: Colors.black,fontSize: screenSize.height * Sizes.MEDIUM),
                                              //   )),
                                              //   decoration: BoxDecoration(
                                              //     borderRadius: BorderRadius.circular(5),
                                              //     color: Colors.white,
                                              //     boxShadow: [
                                              //       BoxShadow(color: Colors.black, spreadRadius: 1),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenSize.height * 0.02,
                                          ),
                                          Text(
                                            'Gallery',
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: screenSize.height *
                                                    Sizes.MEDIUM,
                                                fontWeight:
                                                    AppTextWeight.boldWeight),
                                          ),
                                          SizedBox(
                                            height: screenSize.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors.lightBlack,
                                                ),
//                          color: AppColors.lightBlack,
                                                height: screenSize.height * 0.2,
                                                width: screenSize.width * 0.35,
                                                child: Center(
                                                    child: InkWell(
                                                        onTap: () {
                                                          Get.to(() => ImagePreview(
                                                              src: widget
                                                                  .profileModel
                                                                  .galleryOne));
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image.network(
                                                            widget.profileModel
                                                                .galleryOne,
                                                            fit: BoxFit.cover,
                                                            height: screenSize
                                                                    .height *
                                                                0.2,
                                                          ),
                                                        ))),
                                              ),
                                              SizedBox(
                                                width: screenSize.width * 0.08,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors.lightBlack,
                                                ),
//                          color: AppColors.lightBlack,
                                                height: screenSize.height * 0.2,
                                                width: screenSize.width * 0.35,
                                                child: Center(
                                                    child: InkWell(
                                                        onTap: () {
                                                          Get.to(() => ImagePreview(
                                                              src: widget
                                                                  .profileModel
                                                                  .galleryTwo));
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image.network(
                                                            widget.profileModel
                                                                .galleryTwo,
                                                            fit: BoxFit.cover,
                                                            height: screenSize
                                                                    .height *
                                                                0.2,
                                                          ),
                                                        ))),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenSize.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors.lightBlack,
                                                ),
//                          color: AppColors.lightBlack,
                                                height: screenSize.height * 0.2,
                                                width: screenSize.width * 0.28,
                                                child: Center(
                                                    child: InkWell(
                                                        onTap: () {
                                                          Get.to(() => ImagePreview(
                                                              src: widget
                                                                  .profileModel
                                                                  .galleryThree));
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image.network(
                                                            widget.profileModel
                                                                .galleryThree,
                                                            fit: BoxFit.cover,
                                                            height: screenSize
                                                                    .height *
                                                                0.2,
                                                          ),
                                                        ))),
                                              ),
                                              SizedBox(
                                                width: screenSize.width * 0.03,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors.lightBlack,
                                                ),
//                          color: AppColors.lightBlack,
                                                height: screenSize.height * 0.2,
                                                width: screenSize.width * 0.28,
                                                child: Center(
                                                    child: InkWell(
                                                        onTap: () {
                                                          Get.to(() => ImagePreview(
                                                              src: widget
                                                                  .profileModel
                                                                  .galleryFour));
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image.network(
                                                            widget.profileModel
                                                                .galleryFour,
                                                            fit: BoxFit.cover,
                                                            height: screenSize
                                                                    .height *
                                                                0.2,
                                                          ),
                                                        ))),
                                              ),
                                              SizedBox(
                                                width: screenSize.width * 0.03,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors.lightBlack,
                                                ),
//                          color: AppColors.lightBlack,
                                                height: screenSize.height * 0.2,
                                                width: screenSize.width * 0.28,
                                                child: Center(
                                                    child: InkWell(
                                                        onTap: () {
                                                          Get.to(() => ImagePreview(
                                                              src: widget
                                                                  .profileModel
                                                                  .galleryFive));
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image.network(
                                                            widget.profileModel
                                                                .galleryFive,
                                                            fit: BoxFit.cover,
                                                            height: screenSize
                                                                    .height *
                                                                0.2,
                                                          ),
                                                        ))),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    ));
  }

  static showMessage(message) {
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
