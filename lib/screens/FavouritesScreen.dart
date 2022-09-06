import 'dart:convert';

import 'package:band_baaja/screens/ProfileDetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiffy/jiffy.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/ProfileModel.dart';
import '../constants/ApiContants.dart';
import '../constants/app_data.dart';
import 'package:http/http.dart' as http;


class FavouritesScreen extends StatefulWidget {
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<ProfileModel> pmodel =  [];
  var id;
  var looking;
  var isLoading= false;
  getUserData() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    var u = sp.getString('id');
    var l = sp.getString('looking');
    setState(() {
      id = u;
      looking =l;
      isLoading = true;
    });
    getProfiles(id,looking);
  }
  getProfiles(i,lo) async{

    var jsonData = null;
    print(ApiConstants.GET_PROFILES+"?id="+i+"&gen="+lo);
    var response = await http.get(Uri.parse(ApiConstants.GET_PROFILES+"?id="+i+"&gen="+lo));
    if(response.statusCode == 200){
      if(response.body == 'error'){
        setState(() {
          isLoading = false;
        });
      }
      else{
        setState(() {
          jsonData = json.decode(response.body);
          print(jsonData['data']);
          for(var a in jsonData['data']){
            setState(() {
              isLoading = false;
              pmodel.add(ProfileModel(
                  id: a['id'],
                  firstname: a['first_name'],
                  lastname: a['last_name'],
                  caste: a['caste'],
                  profession: a['profession'],
                  email: a['email'],
                  address: a['address'] ?? ' ',
                  about: a['about'] ?? ' ',
                  cover: a['cover_image'] ?? ApiConstants.NO_IMAGE,
                  dob: Jiffy(a['dob'], "yyyy-MM-dd").fromNow().substring(0,2),
                  gender: a['gender'],
                  interest: a['interest'],
                  phone: a['phone'],
                  profile: a['profile_image'],
                  galleryOne: a['gallery_one'] ?? ApiConstants.NO_IMAGE,
                  galleryTwo: a['gallery_two'] ?? ApiConstants.NO_IMAGE,
                  galleryThree: a['gallery_three'] ?? ApiConstants.NO_IMAGE,
                  galleryFour: a['gallery_four'] ?? ApiConstants.NO_IMAGE,
                  galleryFive: a['gallery_five'] ?? ApiConstants.NO_IMAGE
              ));
            });

          }
        });
      }
//       print(response.body);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Widget profileBox(var size,i){
    return InkWell(
        onTap: (){
          Get.to(()=>ProfileDetail(profileModel: pmodel[i],));
        },
        child:
        Center(child: SizedBox(
          height: size.height * 0.18,
          width: size.width * 0.36,
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: pmodel[i].profile == null ? Image.asset("assets/one.jpg",fit: BoxFit.cover,)
                    : Image.network(ApiConstants.BASE+pmodel[i].profile,fit: BoxFit.cover),

              ),
              Positioned(
                  bottom: 20,
                  left: 10,
                  right: 10,
                  child: Text(pmodel[i].firstname+', '+pmodel[i].dob.toString(),style: TextStyle(fontWeight: AppTextWeight.boldWeight,color: AppColors.secondryColor,fontSize: size.height * 0.021),)),
            ],
          ),
        )
        ));

  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Padding(
        padding: EdgeInsets.only(top: screenSize.height * 0.05,left: screenSize.width * 0.07,right: screenSize.width *0.07),
    child:Container(
      color: HexColor('#fafafa'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.favourite,textAlign: TextAlign.start,style: TextStyle(color: AppColors.black,fontWeight: AppTextWeight.boldWeight,fontSize:MediaQuery.of(context).size.height * Sizes.EXTRALARGE),),
          SizedBox(height: screenSize.height * 0.01),
          Text(AppText.matchesDashboard,textAlign: TextAlign.start,style: TextStyle(color: AppColors.black,fontWeight: AppTextWeight.normalWeight,fontSize: MediaQuery.of(context).size.height *Sizes.MEDIUM),),
          SizedBox(height: screenSize.height * 0.01),
          Row(children: <Widget>[
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Divider(
                    color: Colors.black,
                    height: 36,
                  )),
            ),
            Text(AppText.today,style: TextStyle(fontSize: MediaQuery.of(context).size.height * Sizes.SMALL),),
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Divider(
                    color: Colors.black,
                    height: 36,
                  )),
            ),
          ]),
          SizedBox(height: screenSize.height * 0.01),
          isLoading ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),) :Container(
              height: screenSize.height * 0.65,
              child:
              GridView.builder(

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (_, index) {
                  return profileBox(screenSize,index);
                },
                itemCount: pmodel.length,
              )
          )

        ],
      ),
    )
    );
  }
}
