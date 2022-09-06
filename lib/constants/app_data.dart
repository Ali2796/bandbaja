import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';

class Sizes{
  static var SMALL = 0.020;
  static var MEDIUM = 0.020;
  static var LARGE = 0.035;
  static var EXTRALARGE = 0.045;
}
class AppColors{
  static var primaryColor = HexColor('#e94057');
  static var secondryColor = Colors.white;
  static var accentColor = HexColor('#fceced');
  static var lightBlack = Colors.black26;
  static var black = Colors.black;
  static var bgColor= HexColor('#fafafa');
}

class AppTextWeight{
  static var normalWeight = FontWeight.normal;
  static var mediumWeight = FontWeight.w400;
  static var largeWeight = FontWeight.w900;
  static var boldWeight = FontWeight.bold;
}
class AppText{

  static var algorithmImage = 'assets/one.jpeg';
  static var algorithm = 'Welcome';
  static var algorithmDetail = 'Users going through a vetting process to ensure you never match with bots.';
  static var matchesImage = 'assets/two.jpg';
  static var matches = 'Matches';
  static var matchesDetail = 'We match you with people that have a large array of similar interests.';
  static var premiumImage = 'assets/three.jpg';
  static var preminum = 'Premium';
  static var preminumDetail = 'Sign up today and enjoy the first month of premium benefits on us.';

  static var createAccount = 'Create an account';
  static var alreadyAccount ='Already have an account?';
  static var signin ='Sign In';

  static var profileDetails ='Profile Details';
  static var hintFirstName = 'First Name';
  static var hintLastName = 'Last Name';
  static var hintEmail = 'Email';
  static var hintPhone = 'Phone';
  static var chooseDate = 'Choose birthday date';
  static var birthday = 'Birthday';
  static var hintPassword = 'Password';
  static var confirmText = 'Confirm';
  static var hintProfession = 'Profession';
  static var hintAddress = 'Address';
  static var hintAbout = 'About';


  static var male= 'Male';
  static var female ='Female';
  static var offer= 'Offer';
  static var boyBand= 'Boy WithOut Band';
  static var girlBand= 'Girl WithOut Band';
  static var prWale= 'PR Wale';

  static var selectOne = 'Select One';
  static var about = 'Describe Yourself';
  static var lookingfor = 'Looking for';

  static var matchesDashboard = 'This is a list of people who have liked you and your matches.';
  static var today = 'Today';
  static var favourite = 'Favourite';

  static var termofuse = 'Term of use';
  static var privacypolicy = 'Privacy Policy';


}

class RazorpayManager{
  static String razorPayApiKey = 'rzp_test_ZsBVt0O38fpX8J';
  static double payment=500*100;
}