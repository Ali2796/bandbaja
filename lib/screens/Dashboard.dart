import 'package:band_baaja/constants/app_data.dart';
import 'package:band_baaja/screens/MatchesScreen.dart';
import 'package:band_baaja/screens/UpdateProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    //var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset:false,
      body: SafeArea(
        child:  Column(

          children: [
           // index == 0 ? MatchesScreen() : index == 1 ? FavouritesScreen() : UpdateProfile()
            index == 0 ? const MatchesScreen() :  UpdateProfile()

          ],
        ),
      ),

        bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: index,
            onTap: (int i) {
              setState(() {
                index = i;
              }
              );
            },
            items: [
              BottomNavigationBarItem(
                label: 'a',
                  icon: const Icon(Icons.copy_outlined,size: 25,),
                activeIcon: Icon(Icons.copy_outlined,color: AppColors.primaryColor,size: 30,)
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Ionicons.heart),
              //   label: 'a',
              //     activeIcon: Icon(Ionicons.heart,color: AppColors.primaryColor,)

              //),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.person,size: 25,),
                  label: 'a',
                  activeIcon: Icon(Icons.person,color: AppColors.primaryColor,size: 30,)

              ),
            ]

        )
    );
  }
}
