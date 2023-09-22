import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../src/model/baseSideMenuModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart';
//Global Declaration Starts

//Global Variable Declaration Starts
const storage = FlutterSecureStorage();
const Map<String, String> header = {"Content-Type": "application/json"};
bool internetAvailable = true,
    internetStatus = true,
    otpSent = false,
    otpSend = false,
    mobileVerify = false,
    submitVerify = false,
    dlmPage = false;
int countryId = 0,
    stateId = 0,
    allowNameEdit = 0,
    otpTimer = 60,
    resendOtpTime = 60,
    ebooksLength = 0,
    addOnCourseData = 0,
    masterDivisionId = 1,
    courseServiceProviderId = 1;
DateTime dateTime = DateTime.now(), startDate = DateTime(1970, 1, 1);
String loading = 'assets/images/loading.gif',
    currency = '\u{20B9}',
    companyCode = '',
    logo = 'assets/images/logo/caddcentre.svg',
    logoLogin = 'assets/images/logo/caddcentre_login.svg',
    splashScreen = logo,
    preCacheImage = 'assets/images/logo/caddcentre.png',
    vimeoToken = "dd870720d92e8f7fc3dca0bf3f3d3310",
    redirectUrl = 'https://caddcentre.com',
    clientId = '78s89c33o95e7l',
    clientSecret = 'M8H14I7aXtirQYHr',
    serverClientId =
        '37673187103-l68qnp79t46jm6mdo0cjbc20tome9l6l.apps.googleusercontent.com',
    facebookUserField = "name,email,picture.width(200)",
    errorMsg = "Something went wrong, please try after sometime",
    appTitle = 'CADD Centre - Student App',
    baseAppId = '1',
    appId = '1';
List<String> googleScope = [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
    facebookPermission = ["name,email,user_profile"];
dynamic profileData,
    paymentData = '',
    labData,
    nsdcData,
    emailId,
    password,
    userName = '',
    firstName = '',
    lastName = '',
    profilePicture = '',
    loginId = '',
    token = '',
    userId,
    addCount = 0,
    menuItems,
    userEmail,
    userMobile,
    addOnResult,
    encodedImage,
    selfPacedData,
    courseData,
    courseId,
    addOnResultData,
    quizResult,
    quesList,
    answerList,
    quizList,
    quizResultData,
    body,
    result,
    img64,
    labResultData;
//Global Variable Declaration Ends

//Global Color Declaration Starts
const kGreenColor = Color(0xFF6AC259);
const kBlueColor = Colors.blue;
const colorCode = Color(0xFFE31E24);
const Color facebookColor = Color(0xff39579A);
const Color twitterColor = Color(0xff00ABEA);
const Color instagramColor = Color(0xffBE2289);
const Color whatsappColor = Color(0xff075E54);
const Color linkedinColor = Color(0xff0085E0);
const Color githubColor = Color(0xff202020);
const Color googleColor = Color(0xffDF4A32);
const splashColorCode = colorCode;
const gradientColor = [
  Color.fromARGB(255, 255, 255, 255),
  Color.fromARGB(255, 254, 225, 225),
  Color.fromARGB(255, 255, 255, 255)
];

List<Alignment> get getAlignments => [
      Alignment.bottomLeft,
      Alignment.bottomRight,
      Alignment.topRight,
      Alignment.topLeft,
    ];
const Color inputBoxBorder = Colors.black;
const Color inputBoxFocusBorder = Colors.blue;
//Global Color Declaration Ends
List<BaseSideMenuModel> baseSideMenu = [];
List<TabItem<dynamic>> bottomNavBar = [];

//Global Fonts Declaration Starts
final fontWhiteStyle = const TextStyle(color: Colors.white, fontSize: 11),
    fontStyledesk = const TextStyle(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13),
    fontCompleteStyledesk = const TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
    fontStyle7 = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),
    fontStyle1 = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    fontStyle74 = TextStyle(
      color: Colors.black87.withOpacity(0.8),
      fontWeight: FontWeight.normal,
      fontSize: 16,
    ),
    //course title name
    fontStyleWeb = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ), //course title name Web
    fontStyle3 = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ), //hours and Concept covered
    fontStyle3Web = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ), //hours and Concept covered
    fontStyleReg = const TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: 15,
    ),
    fontStyleRegWeb = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    fontStyleSubNoDataFound = const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    ),
    fontStyleLabel = TextStyle(
      color: Colors.black87,
      fontSize: currentScreen == 'tab' ? 16 : 14,
    ), // software course name
    fontDlmStyle = TextStyle(
        color: const Color.fromARGB(255, 10, 81, 139),
        fontWeight: FontWeight.w600,
        fontSize: currentScreen == 'tab' ? 15 : 12),
    fontSelfPaced = TextStyle(
        color: const Color.fromARGB(255, 10, 81, 139),
        fontWeight: FontWeight.w500,
        fontSize: currentScreen == 'tab' ? 20 : 15),
    fontRed = TextStyle(
        color: colorCode,
        fontWeight: FontWeight.w500,
        fontSize: currentScreen == 'tab' ? 20 : 16),
    fontReportGrey = TextStyle(
      color: const Color(0xFF797979),
      fontWeight: FontWeight.w400,
      fontSize: currentScreen == 'tab' ? 20 : 14,
    ),
    fontReportGreenBig = TextStyle(
      color: const Color(0xFF4BAC29),
      fontWeight: FontWeight.w700,
      fontSize: currentScreen == 'tab' ? 20 : 14,
    ),
    fontQuizQuestionStyle = const TextStyle(
        color: Color(0xffe61f26),
        fontSize: 14,
        fontWeight: FontWeight.w500); // profile and nsdc form

fontDeliverables(color) {
  return TextStyle(
      color: color, height: 1.5, fontSize: 16, fontWeight: FontWeight.bold);
}

fontDeliverablesTab(color) {
  return TextStyle(
      color: color, height: 1.5, fontSize: 20, fontWeight: FontWeight.bold);
}

fontChipWidget(color) {
  return TextStyle(color: color, fontSize: 12);
}

fontChipWidgetTab(color) {
  return TextStyle(
    color: color,
    fontSize: 18,
  );
}
//Global Fonts Declaration Ends

//Global Spacing Declaration Starts

const double kDefaultPadding = 20.0;
const flushbarMobile = EdgeInsets.all(15);

//Global Spacing Declaration Ends

//Global Rupee Converter Starts

final oCcy = NumberFormat.currency(
  name: "",
  locale: 'en_IN',
  decimalDigits: 2, // change it to get decimal places
  symbol: '₹',
);

final numberFormat = NumberFormat.currency(name: "", locale: 'en_IN');

final oCcyCo = NumberFormat.currency(
  name: "",
  locale: 'en_IN',
  decimalDigits: 0, // change it to get decimal places
  symbol: '₹',
);
//Global Rupee Converter Ends

//Global Declaration Ends
