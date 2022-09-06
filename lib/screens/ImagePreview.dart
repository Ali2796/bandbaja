import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_data.dart';

class ImagePreview extends StatelessWidget {
  var src;
  ImagePreview({this.src});
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.network(this.src,fit: BoxFit.cover,height: screenSize.height,width: screenSize.width,),

              ),
              Positioned(
                  top: 10,
                  left: -15,
                  child:RawMaterialButton(
                    onPressed: () {
                      Get.back();
                   //   Get.back();
                    },
                    elevation: 2.0,
                    fillColor: Colors.black12,
                    child: Icon(Icons.arrow_back, color: Colors.white,size: screenSize.height * 0.03),
                    padding: EdgeInsets.all(1.5),
                    shape: CircleBorder(

                        side: BorderSide(
                          color: Colors.white,
                          width: 2,
                        )),
                  )
                  ),

            ],
          ),

        )
    );
  }
}
