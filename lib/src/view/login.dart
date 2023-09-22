// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: public_member_api_docs
// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:account_picker/account_picker.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../common/appUpgrade.dart';
import '../../common/alertDialog.dart';
import '../../common/networkApi.dart';
import '../../common/toast.dart';
import '../../common/decorationScreen.dart';
import '../../common/internetCheck.dart';
import '../../common/validateFunction.dart';
import '../../constants.dart';
import '../../main.dart';
import '../controller/loginController.dart';

//Login Screen Starts
class LoginLive extends StatefulWidget {
  const LoginLive({super.key});

  @override
  State<LoginLive> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginLive> {
  //Variable Declaration Starts
  final RoundedLoadingButtonController btnSendController =
          RoundedLoadingButtonController(),
      btnVerifyController = RoundedLoadingButtonController(),
      btnResendController = RoundedLoadingButtonController();
  final loginForm = GlobalKey<FormState>();
  final emailController = TextEditingController(),
      otpController = TextEditingController();
  /*final FacebookAuth facebookAuth = FacebookAuth.instance;
  String? authorizationCode,state;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    serverClientId: serverClientId,
    scopes: googleScope,
  );*/
  Map<String, dynamic>? userData;
  // AccessToken? accessToken;
  bool isSignIn = false,
      google = false,
      showKeyboard = false,
      accountPicked = false;
  String hintText = 'Mobile Number',
      iconName = 'mobile',
      email = '',
      otpError = '';
  String? existingUser = '0', appSignature = "", appVersionError = '';
  int charLimit = 10, otpTimer = 60, resendOtpTime = 0;
  int currentIndex = 0;
  double imageHeight = 80.0, imageWidth = 150.0;
  FocusNode otpFocus = FocusNode(), accountField = FocusNode();
  TextInputType inputType = TextInputType.phone;
  Timer? timer;
  //Package Information
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  static const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
  static const fillColor = Color.fromRGBO(243, 246, 249, 0);
  static const borderColor = Color.fromRGBO(23, 171, 144, 0.4);
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: borderColor),
    ),
  );

  //Variable Declaration Ends

  //initialize Starts
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    setState(() {
      otpSent = false;
      colorCode;
    });
    if (Platform.isAndroid || Platform.isIOS) {
      upGraderApi(context);
    }
    Future.delayed(const Duration(seconds: 0), () async {
      await storage.containsKey(key: "appLogId").then((value) async {
        if (value) {
          await storage.delete(key: 'appLogId');
        }
        logDetails();
      });
    });
    _initPackageInfo();
    initReferrerDetails();
  }

  //initialize Ends

  //Dispose Widget Starts
  @override
  void dispose() {
    emailController.dispose();
    accountField.unfocus();
    otpFocus.unfocus();
    btnSendController.reset();
    timer?.cancel();
    if (Platform.isAndroid) {
      SmartAuth().removeSmsListener();
    }
    super.dispose();
  }
  //Dispose Widget Starts

  //Main Widget Starts
  @override
  Widget build(BuildContext context) {
    //Variable Declaration Inside Widget
    Size size = MediaQuery.sizeOf(context);
    double width = size.width;
    double height = size.height;
    double screenWidth = size.width;
    double screenHeight = size.height;
    double bottom = width > height ? width - height : height - width;
    if (width > 920) //desktop
    {
      currentScreen = 'desktop';
      if (width > 1200) {
        vertical = height * 0.01;
      } else {
        vertical = height * 0.13;
      }
      horizontal = width * 0.3;
      padding = height * 0.01;
      containerWidth = width * 0.4;
    } else if (width > 420 && width < 920 && Platform.isAndroid) //tab
    {
      currentScreen = 'tab';
      vertical = height * 0.01;
      horizontal = width * 0.2;
      padding = height * 0.01;
    } else if (width < 420 && Platform.isAndroid) //mobile
    {
      currentScreen = 'mobile';
      containerHeight = height;
      containerWidth = width;
      vertical = height * 0.1;
      horizontal = 20;
      padding = 10;
    } else if (width < 600 && Platform.isIOS) //mobile
    {
      currentScreen = 'mobile';
      containerHeight = height;
      containerWidth = width;
      vertical = height * 0.1;
      horizontal = 20;
      padding = 10;
    }
    if (bottom > 700) {
      //desktop
      bottom *= 0.1;
      height *= 0.01;
      width *= 0.3;
    } else if (bottom <= 500 && bottom > 350) {
      //tab
      if (bottom > 430 && bottom < 490) {
        bottom *= 0.1;
        height *= 0.1;
        width *= 0.25;
      } else if (bottom > 350 && bottom < 430) {
        bottom *= 0.5;
        height *= 0.01;
        width *= 0.01;
      } else {
        bottom *= 0.8;
        height *= 0.01;
        width *= 0.01;
      }
    } else {
      //mobile
      bottom *= 0.6;
      height *= 0.03;
      width *= 0.01;
      imageWidth = width * 3;
      imageHeight = height * 3;
    }
    //Variable Declaration Inside Widget Ends
    //Widget Return Starts
    return WillPopScope(
      onWillPop: () async {
        showExitPopup(context);
        return false; // return true if the route to be popped
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: loginForm,
          child: SingleChildScrollView(
            child: Container(
              decoration: currentScreen == 'mobile'
                  ? const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ]),
                    )
                  : const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/login_banner.jpg'),
                          fit: BoxFit.cover)),
              height: screenHeight,
              width: screenWidth,
              child: Column(
                mainAxisAlignment: currentScreen == 'mobile'
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: currentScreen == 'mobile' ? vertical * 10 : 690,
                    width: currentScreen == 'tab' ? 580 : 500,
                    child: currentScreen == 'mobile'
                        ? Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: screenWidth,
                                    height: vertical * 3,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/login_mobile.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                              Container(
                                height: currentScreen == 'mobile'
                                    ? vertical * 8.52
                                    : vertical * 7.5,
                                width: screenWidth,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    )),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 220,
                                      height: 100,
                                      padding: const EdgeInsets.all(2),
                                      child: SvgPicture.asset(
                                        logoLogin,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 3, left: 10, right: 10),
                                            margin: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              color: iconName == 'mobile'
                                                  ? colorCode
                                                  : Colors.white,
                                              width: 3.0, // Underline thickness
                                            ))),
                                            child: GestureDetector(
                                              onTap: () {
                                                timer?.cancel();
                                                accountField.unfocus();
                                                loginForm.currentState!.reset();
                                                emailController.clear();
                                                setState(() {
                                                  resendOtpTime = 0;
                                                  otpSent = false;
                                                  resendOtpTime = 0;
                                                  showKeyboard = true;
                                                  otpController.clear();
                                                  inputType =
                                                      TextInputType.phone;
                                                  hintText = 'Mobile Number';
                                                  iconName = 'mobile';
                                                  charLimit = 10;
                                                });
                                              },
                                              child: Text(
                                                'Mobile No',
                                                style: TextStyle(
                                                  color: iconName == 'mobile'
                                                      ? colorCode
                                                      : Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 3, right: 10, left: 10),
                                            margin: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              color: iconName == 'email'
                                                  ? colorCode
                                                  : Colors.white,
                                              width: 3.0, // Underline thickness
                                            ))),
                                            child: GestureDetector(
                                              child: Text(
                                                'Email Id',
                                                style: TextStyle(
                                                  color: iconName == 'email'
                                                      ? colorCode
                                                      : Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              onTap: () {
                                                timer?.cancel();
                                                accountField.unfocus();
                                                loginForm.currentState!.reset();
                                                emailController.clear();
                                                setState(() {
                                                  resendOtpTime = 0;
                                                  otpSent = false;
                                                  showKeyboard = true;
                                                  otpController.clear();
                                                  inputType = TextInputType
                                                      .emailAddress;
                                                  hintText = 'Email Id';
                                                  iconName = 'email';
                                                  charLimit = 40;
                                                });
                                              },
                                            ),
                                          ),
                                        ]),
                                    const SizedBox(height: 40),
                                    BootstrapCol(
                                      sizes:
                                          'col-sm-12 col-md-10 col-lg-10 col-xl-10',
                                      child: TextFormField(
                                        focusNode: accountField,
                                        controller: emailController,
                                        keyboardType: inputType,
                                        readOnly: otpSent,
                                        onTap: () {
                                          if (!accountPicked &&
                                              Platform.isAndroid) {
                                            accountField.unfocus();
                                            showAccountList(iconName);
                                          } else {
                                            accountPicked = !accountPicked;
                                          }
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            email = value;
                                          });
                                          if (value.length == 10) {
                                            if (iconName == 'mobile') {
                                              accountField.unfocus();
                                            }
                                          }
                                        },
                                        maxLength: charLimit,
                                        inputFormatters: [
                                          iconName == 'mobile'
                                              ? FilteringTextInputFormatter
                                                  .digitsOnly
                                              : FilteringTextInputFormatter
                                                  .allow(RegExp(
                                                      "[a-zA-Z0-9.!@#\$%&'*+-/=?^_`{|}~]"))
                                        ],
                                        cursorColor: Colors.blue,
                                        decoration: DecorationScreen()
                                            .loginDecorationStyle(
                                          hintText,
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              timer?.cancel();
                                              accountField.unfocus();
                                              loginForm.currentState!.reset();
                                              emailController.clear();
                                              otpController.clear();
                                              setState(() {
                                                resendOtpTime = 0;
                                                otpSent = false;
                                                otpController.clear();
                                                if (iconName == 'mobile') {
                                                  inputType = TextInputType
                                                      .emailAddress;
                                                  hintText = 'Email Id';
                                                  iconName = 'email';
                                                  charLimit = 40;
                                                } else {
                                                  inputType =
                                                      TextInputType.number;
                                                  hintText = 'Mobile Number';
                                                  iconName = 'mobile';
                                                  charLimit = 10;
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              iconName == 'mobile'
                                                  ? Icons
                                                      .mobile_friendly_outlined
                                                  : Icons.email_outlined,
                                              color: colorCode,
                                              size: 16,
                                            ),
                                          ),
                                          iconName == 'mobile'
                                              ? SizedBox(
                                                  width:
                                                      currentScreen == 'mobile'
                                                          ? screenWidth * 0.21
                                                          : 90,
                                                  child:
                                                      const CountryCodePicker(
                                                    enabled: false,
                                                    flagWidth: 20,
                                                    padding: EdgeInsets.zero,
                                                    onChanged: print,
                                                    initialSelection: 'IN',
                                                    favorite: ['+91', 'IN'],
                                                    showCountryOnly: false,
                                                    showOnlyCountryWhenClosed:
                                                        false,
                                                    alignLeft: false,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        validator: (value) {
                                          if (iconName == 'mobile') {
                                            if (value == null ||
                                                value.isEmpty ||
                                                value.length < 10) {
                                              return 'Enter a valid number';
                                            }
                                          } else {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Enter a valid email id';
                                            }
                                            if (!isEmailValid(value)) {
                                              return 'Enter a valid email id';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    BootstrapCol(
                                      sizes:
                                          'col-sm-12 col-md-10 col-lg-9 col-xl-9',
                                      child: Visibility(
                                        visible: otpSent,
                                        child: Column(
                                          children: [
                                            const Text('Enter your OTP'),
                                            const SizedBox(height: 10),
                                            Pinput(
                                              androidSmsAutofillMethod:
                                                  AndroidSmsAutofillMethod
                                                      .smsRetrieverApi,
                                              listenForMultipleSmsOnAndroid:
                                                  true,
                                              autofillHints: const [
                                                AutofillHints.oneTimeCode
                                              ],
                                              controller: otpController,
                                              focusNode: otpFocus,
                                              pinputAutovalidateMode:
                                                  PinputAutovalidateMode
                                                      .onSubmit,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              validator: (value) {
                                                if (value == "" ||
                                                    value == null ||
                                                    value.length < 4) {
                                                  otpFocus.unfocus();
                                                  return "Enter your 4 digit Otp";
                                                }
                                                if (otpError != '') {
                                                  return 'Invalid Otp';
                                                }
                                                return null;
                                              },
                                              onChanged: (pin) {
                                                setState(() {
                                                  otpError = '';
                                                });
                                              },
                                              onCompleted: (pin) async {
                                                otpFocus.unfocus();
                                                setState(() {
                                                  otpError = '';
                                                });
                                                btnVerifyController.start();
                                              },
                                              focusedPinTheme:
                                                  defaultPinTheme.copyWith(
                                                decoration: defaultPinTheme
                                                    .decoration!
                                                    .copyWith(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color:
                                                          focusedBorderColor),
                                                ),
                                              ),
                                              submittedPinTheme:
                                                  defaultPinTheme.copyWith(
                                                decoration: defaultPinTheme
                                                    .decoration!
                                                    .copyWith(
                                                  color: fillColor,
                                                  borderRadius:
                                                      BorderRadius.circular(19),
                                                  border: Border.all(
                                                      color:
                                                          focusedBorderColor),
                                                ),
                                              ),
                                              errorPinTheme: defaultPinTheme
                                                  .copyBorderWith(
                                                border: Border.all(
                                                    color: Colors.redAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(5)),
                                    Visibility(
                                      visible: !otpSent,
                                      child: BootstrapCol(
                                        sizes:
                                            'col-sm-6 col-md-6 col-lg-6 col-xl-6',
                                        child: SizedBox(
                                          width: screenWidth * 0.2,
                                          height: screenHeight * 0.06,
                                          child: RoundedLoadingButton(
                                            successIcon: Icons.check_outlined,
                                            failedIcon:
                                                Icons.error_outline_outlined,
                                            controller: btnSendController,
                                            successColor: Colors.green,
                                            color: colorCode,
                                            valueColor: Colors.white,
                                            borderRadius: 10,
                                            onPressed: () =>
                                                sendotp(btnSendController),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.send_outlined,
                                                    size: 16,
                                                    color: Colors.white),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text('Get OTP',
                                                    style: fontStyle1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                    Visibility(
                                      visible: otpSent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Spacer(),
                                          SizedBox(
                                            width: currentScreen == 'tab'
                                                ? screenWidth * 0.2
                                                : screenWidth * 0.3,
                                            height: screenHeight * 0.06,
                                            child: RoundedLoadingButton(
                                              successIcon: Icons.check_outlined,
                                              failedIcon:
                                                  Icons.error_outline_outlined,
                                              controller: btnVerifyController,
                                              successColor: Colors.green,
                                              color: colorCode,
                                              valueColor: Colors.white,
                                              borderRadius: 10,
                                              onPressed: () async {
                                                verifyOTP();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                      Icons.check_box_outlined,
                                                      size: 16,
                                                      color: Colors.white),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text('Verify OTP',
                                                      style: fontStyle1),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          if (resendOtpTime > 0) ...[
                                            Text(
                                                "You can resend \n   OTP in $resendOtpTime s",
                                                style: const TextStyle(
                                                    color: colorCode)),
                                          ] else ...[
                                            SizedBox(
                                              width: currentScreen == 'tab'
                                                  ? screenWidth * 0.2
                                                  : screenWidth * 0.3,
                                              height: screenHeight * 0.06,
                                              child: RoundedLoadingButton(
                                                  successIcon:
                                                      Icons.check_outlined,
                                                  failedIcon: Icons
                                                      .error_outline_outlined,
                                                  controller:
                                                      btnResendController,
                                                  successColor: Colors.green,
                                                  color: colorCode,
                                                  valueColor: Colors.white,
                                                  borderRadius: 10,
                                                  onPressed: () {
                                                    otpController.clear();
                                                    resendOtp(
                                                        btnResendController);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                          Icons
                                                              .refresh_outlined,
                                                          size: 16,
                                                          color: Colors.white),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text('Resend OTP',
                                                          style: fontStyle1),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // InkWell(
                                    //     onTap: () {
                                    //       context.pushNamed('/studentEnquiry',
                                    //           params: {
                                    //             "verified": 'mobile',
                                    //             "user_id": '8778718220',
                                    //             "existing_otp": '1234'
                                    //           });
                                    //     },
                                    //     child: const Text(
                                    //       "Register",
                                    //       style: TextStyle(
                                    //           color: Colors.blue,
                                    //           decoration:
                                    //               TextDecoration.underline,
                                    //           decorationThickness: 3,
                                    //           decorationColor: Colors.blue),
                                    //     )),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    InkWell(
                                        onTap: () {
                                          context.pushNamed("/privacy-policy");
                                        },
                                        child: const Text(
                                          "Privacy Policy",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationThickness: 3,
                                              decorationColor: Colors.blue),
                                        )),
                                    /* const SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomWidgets.socialButtonCircle(
                                              facebookColor,
                                              FontAwesomeIcons.facebookF,
                                              iconColor: Colors.white,
                                              onTap: () {
                                            signInWithFacebook();
                                          }),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CustomWidgets.socialButtonCircle(
                                              googleColor,
                                              FontAwesomeIcons.googlePlusG,
                                              iconColor: Colors.white,
                                              onTap: () {
                                            signInWithGoogle();
                                          }),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CustomWidgets.socialButtonCircle(
                                              linkedinColor,
                                              FontAwesomeIcons.linkedin,
                                              iconColor: Colors.white,
                                              onTap: () {
                                            signInWithLinkedin();
                                          }),
                                        ],
                                      ),
                                    ),*/
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                  "App version ${_packageInfo.version}.${_packageInfo.buildNumber}"),
                            ],
                          )
                        //tab view
                        : BootstrapCol(
                            sizes: 'col-sm-12 col-md-12 col-lg-12 col-xl-12',
                            child: Card(
                              surfaceTintColor: Colors.white,
                              elevation: 8,
                              child: SizedBox(
                                height: height * 0.72,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10),
                                    Container(
                                        width: 220,
                                        height: 95,
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset(
                                          logoLogin,
                                        )),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 3, left: 10, right: 10),
                                            margin: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              color: iconName == 'mobile'
                                                  ? colorCode
                                                  : Colors.white,
                                              width: 2.0, // Underline thickness
                                            ))),
                                            child: GestureDetector(
                                              onTap: () {
                                                accountField.unfocus();
                                                emailController.clear();
                                                loginForm.currentState!.reset();
                                                timer?.cancel();
                                                setState(() {
                                                  resendOtpTime = 0;
                                                  otpSent = false;
                                                  showKeyboard = true;
                                                  inputType =
                                                      TextInputType.phone;
                                                  hintText = 'Mobile Number';
                                                  iconName = 'mobile';
                                                  charLimit = 10;
                                                });
                                              },
                                              child: Text(
                                                'Mobile No',
                                                style: TextStyle(
                                                  color: iconName == 'mobile'
                                                      ? colorCode
                                                      : Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 3, right: 10, left: 10),
                                            margin: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              color: iconName == 'email'
                                                  ? colorCode
                                                  : Colors.white,
                                              width: 2.0, // Underline thickness
                                            ))),
                                            child: GestureDetector(
                                              child: Text(
                                                'Email Id',
                                                style: TextStyle(
                                                    color: iconName == 'email'
                                                        ? colorCode
                                                        : Colors.black,
                                                    fontSize: 16),
                                              ),
                                              onTap: () {
                                                accountField.unfocus();
                                                emailController.clear();
                                                loginForm.currentState!.reset();
                                                timer?.cancel();
                                                setState(() {
                                                  resendOtpTime = 0;
                                                  otpSent = false;
                                                  showKeyboard = true;
                                                  inputType = TextInputType
                                                      .emailAddress;
                                                  hintText = 'Email Id';
                                                  iconName = 'email';
                                                  charLimit = 40;
                                                });
                                              },
                                            ),
                                          ),
                                        ]),
                                    const SizedBox(height: 20),
                                    BootstrapCol(
                                      sizes:
                                          'col-sm-12 col-md-10 col-lg-10 col-xl-10',
                                      child: TextFormField(
                                        focusNode: accountField,
                                        controller: emailController,
                                        keyboardType: inputType,
                                        readOnly: otpSent,
                                        onTap: () {
                                          if (!accountPicked &&
                                              Platform.isAndroid) {
                                            accountField.unfocus();
                                            showAccountList(iconName);
                                          } else {
                                            accountPicked = !accountPicked;
                                          }
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            email = value;
                                          });
                                          if (value.length == 10) {
                                            if (iconName == 'mobile') {
                                              accountField.unfocus();
                                            }
                                          }
                                        },
                                        maxLength: charLimit,
                                        inputFormatters: [
                                          iconName == 'mobile'
                                              ? FilteringTextInputFormatter
                                                  .digitsOnly
                                              : FilteringTextInputFormatter
                                                  .allow(RegExp(
                                                      "[a-zA-Z0-9.!@#\$%&'*+-/=?^_`{|}~]"))
                                        ],
                                        cursorColor: Colors.blue,
                                        decoration: DecorationScreen()
                                            .loginDecorationStyle(
                                          hintText,
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              accountField.unfocus();
                                              loginForm.currentState!.reset();
                                              emailController.clear();
                                              setState(() {
                                                otpSent = false;
                                                if (iconName == 'mobile') {
                                                  inputType = TextInputType
                                                      .emailAddress;
                                                  hintText = 'Email Id';
                                                  iconName = 'email';
                                                  charLimit = 40;
                                                } else {
                                                  inputType =
                                                      TextInputType.number;
                                                  hintText = 'Mobile Number';
                                                  iconName = 'mobile';
                                                  charLimit = 10;
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              iconName == 'mobile'
                                                  ? Icons
                                                      .mobile_friendly_outlined
                                                  : Icons.email_outlined,
                                              color: colorCode,
                                              size: 16,
                                            ),
                                          ),
                                          iconName == 'mobile'
                                              ? const SizedBox(
                                                  width: 100,
                                                  child: CountryCodePicker(
                                                    enabled: false,
                                                    flagWidth: 20,
                                                    padding: EdgeInsets.zero,
                                                    onChanged: print,
                                                    initialSelection: 'IN',
                                                    favorite: ['+91', 'IN'],
                                                    showCountryOnly: false,
                                                    showOnlyCountryWhenClosed:
                                                        false,
                                                    alignLeft: true,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        validator: (value) {
                                          if (iconName == 'mobile') {
                                            if (value == null ||
                                                value.isEmpty ||
                                                value.length < 10) {
                                              return 'Enter a valid number';
                                            }
                                          } else {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Enter a valid email id';
                                            }
                                            if (!isEmailValid(value)) {
                                              return 'Enter a valid email id';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    BootstrapCol(
                                      sizes:
                                          'col-sm-12 col-md-10 col-lg-9 col-xl-9',
                                      child: Visibility(
                                        visible: otpSent,
                                        child: Column(
                                          children: [
                                            const Text('Enter your OTP'),
                                            const SizedBox(height: 10),
                                            Pinput(
                                              androidSmsAutofillMethod:
                                                  AndroidSmsAutofillMethod
                                                      .smsRetrieverApi,
                                              listenForMultipleSmsOnAndroid:
                                                  true,
                                              controller: otpController,
                                              focusNode: otpFocus,
                                              pinputAutovalidateMode:
                                                  PinputAutovalidateMode
                                                      .onSubmit,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              validator: (value) {
                                                if (value == "" ||
                                                    value == null ||
                                                    value.length < 4) {
                                                  return "Enter your 4 digit Otp";
                                                }
                                                if (otpError != '') {
                                                  return 'Invalid Otp';
                                                }
                                                return null;
                                              },
                                              onChanged: (pin) {
                                                setState(() {
                                                  otpError = '';
                                                  otpController.text = pin;
                                                });
                                              },
                                              onCompleted: (pin) async {
                                                if (pin.length == 4) {
                                                  otpFocus.unfocus();
                                                }
                                                setState(() {
                                                  otpController.text = pin;
                                                });
                                                btnVerifyController.start();
                                              },
                                              focusedPinTheme:
                                                  defaultPinTheme.copyWith(
                                                decoration: defaultPinTheme
                                                    .decoration!
                                                    .copyWith(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color:
                                                          focusedBorderColor),
                                                ),
                                              ),
                                              submittedPinTheme:
                                                  defaultPinTheme.copyWith(
                                                decoration: defaultPinTheme
                                                    .decoration!
                                                    .copyWith(
                                                  color: fillColor,
                                                  borderRadius:
                                                      BorderRadius.circular(19),
                                                  border: Border.all(
                                                      color:
                                                          focusedBorderColor),
                                                ),
                                              ),
                                              errorPinTheme: defaultPinTheme
                                                  .copyBorderWith(
                                                border: Border.all(
                                                    color: Colors.redAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(10)),
                                    Visibility(
                                      visible: !otpSent,
                                      child: BootstrapCol(
                                        sizes:
                                            'col-sm-6 col-md-6 col-lg-6 col-xl-6',
                                        child: SizedBox(
                                          width: screenWidth * 0.2,
                                          height: screenHeight * 0.06,
                                          child: RoundedLoadingButton(
                                            successIcon: Icons.check_outlined,
                                            failedIcon:
                                                Icons.error_outline_outlined,
                                            controller: btnSendController,
                                            successColor: Colors.green,
                                            color: colorCode,
                                            valueColor: Colors.white,
                                            borderRadius: 10,
                                            onPressed: () =>
                                                sendotp(btnSendController),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.send_outlined,
                                                    size: 16,
                                                    color: Colors.white),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text('Get OTP',
                                                    style: fontStyle1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 15)),
                                    BootstrapCol(
                                      sizes:
                                          'col-sm-12 col-md-12 col-lg-12 col-xl-12',
                                      child: Visibility(
                                        visible: otpSent,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Spacer(),
                                            SizedBox(
                                              width: screenWidth * 0.2,
                                              height: screenHeight * 0.06,
                                              child: RoundedLoadingButton(
                                                successIcon:
                                                    Icons.check_outlined,
                                                failedIcon: Icons
                                                    .error_outline_outlined,
                                                controller: btnVerifyController,
                                                successColor: Colors.green,
                                                color: colorCode,
                                                valueColor: Colors.white,
                                                borderRadius: 10,
                                                onPressed: () async {
                                                  verifyOTP();
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .check_box_outlined,
                                                        size: 16,
                                                        color: Colors.white),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text('Verify OTP',
                                                        style: fontStyle1),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            if (resendOtpTime > 0)
                                              Text(
                                                "You can resend \n   OTP in $resendOtpTime s",
                                                style: const TextStyle(
                                                    color: colorCode),
                                              )
                                            else
                                              SizedBox(
                                                width: currentScreen == 'tab'
                                                    ? screenWidth * 0.2
                                                    : screenWidth * 0.3,
                                                height: screenHeight * 0.06,
                                                child: RoundedLoadingButton(
                                                    successIcon:
                                                        Icons.check_outlined,
                                                    failedIcon: Icons
                                                        .error_outline_outlined,
                                                    controller:
                                                        btnResendController,
                                                    successColor: Colors.green,
                                                    color: colorCode,
                                                    valueColor: Colors.white,
                                                    borderRadius: 10,
                                                    onPressed: () {
                                                      otpController.clear();
                                                      setState(() {
                                                        otpError = '';
                                                      });
                                                      otpFocus.requestFocus();
                                                      resendOtp(
                                                          btnResendController);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .refresh_outlined,
                                                            size: 16,
                                                            color:
                                                                Colors.white),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text('Resend OTP',
                                                            style: fontStyle1),
                                                      ],
                                                    )),
                                              ),
                                            const Spacer()
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 10)),
                                    /* InkWell(
                                        onTap: () {
                                          context.pushNamed('/studentEnquiry',
                                              params: {
                                                "verified": 'email',
                                                "user_id": 'test@gmail',
                                                "existing_otp": '1234'
                                              });
                                        },
                                        child: const Text(
                                          "Register",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationThickness: 3,
                                              decorationColor: Colors.blue),
                                        )),*/
                                    InkWell(
                                        onTap: () {
                                          context.pushNamed("/privacy-policy");
                                        },
                                        child: const Text(
                                          "Privacy Policy",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationThickness: 3,
                                              decorationColor: Colors.blue),
                                        )),
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 20)),
                                    /*  const SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomWidgets.socialButtonCircle(
                                              facebookColor,
                                              FontAwesomeIcons.facebookF,
                                              iconColor: Colors.white,
                                              onTap: () {
                                            signInWithFacebook();
                                          }),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CustomWidgets.socialButtonCircle(
                                              googleColor,
                                              FontAwesomeIcons.googlePlusG,
                                              iconColor: Colors.white,
                                              onTap: () {
                                            signInWithGoogle();
                                          }),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CustomWidgets.socialButtonCircle(
                                              linkedinColor,
                                              FontAwesomeIcons.linkedin,
                                              iconColor: Colors.white,
                                              onTap: () {
                                            signInWithLinkedin();
                                          }),
                                        ],
                                      ),
                                    ),*/
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                        "App version ${_packageInfo.version}.${_packageInfo.buildNumber}"),
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 20)),
                                  ],
                                ),
                              ),
                            )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    //Widget Return Ends
  } //Main Widget Ends

  //Send Otp Function Starts
  sendotp(controller) async {
    if (appVersionError != '') {
      messageFlushBar(context, appVersionError!);
      controller.error();
      Future.delayed(const Duration(seconds: 1), () async {
        controller.reset();
      });
      return;
    }
    if (loginForm.currentState!.validate()) {
      await checkInternet().then((value) async => {
            if (value == true)
              {
                await LoginController()
                    .sendOtp(email, context, appId)
                    .then((value) async {
                  if (value == 'Connection Error') {
                    context.pushNamed("/noInternet");
                    return;
                  }
                  if (value) {
                    controller.success();
                    setState(() {
                      otpSent = true;
                    });
                    otpFocus.requestFocus();
                    if (Platform.isAndroid) {
                      await SmartAuth().getSmsCode().then((smsResult) {
                        otpController.text = smsResult.code ?? "";
                        btnVerifyController.start();
                      });
                    } else {
                      // otpController.text = smsResult.code ?? "";
                      btnVerifyController.start();
                    }
                    Future.delayed(const Duration(seconds: 1), () {
                      controller.reset();
                    });
                  } else {
                    controller.error();
                    Future.delayed(const Duration(milliseconds: 1000),
                        () async {
                      controller.reset();
                    });
                  }
                }),
              }
            else
              {controller.reset(), context.push('/noInternet')}
          });
    } else {
      controller.error();
      Future.delayed(const Duration(seconds: 1), () {
        controller.reset();
      });
    }
  }
  //Send Otp Function Ends

  //Resend Otp Function Starts
  resendOtp(controller) async {
    await (checkInternet().then((value) async {
      if (value == true) {
        await LoginController()
            .sendOtp(email, context, appId)
            .then((value) async {
          if (value == "Connection Error") {
            context.pushNamed("/noInternet");
            return;
          }
          if (value) {
            otpFocus.requestFocus();
            controller.success();
            try {
              if (Platform.isAndroid) {
                SmartAuth().getSmsCode().then((smsResult) {
                  otpController.text = smsResult.code ?? "";
                });
              }
            } catch (e) {
              null;
            }
            Future.delayed(const Duration(seconds: 1), () {
              controller.reset();
              timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (timer.tick == 60) {
                  timer.cancel();
                }
                setState(() {
                  resendOtpTime = otpTimer - timer.tick;
                });
              });
            });
          } else {
            controller.reset();
          }
        });
      } else {
        controller.reset();
        context.push('/noInternet');
      }
    }));
  }

  //Resend Otp Function Ends

  //Package Information Get Function Starts
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    userName = await storage.read(key: 'username');
    await storage.write(key: 'current_screen', value: currentScreen);
    if (Platform.isAndroid) {
      await SmartAuth().getSmsCode();
    }
  }
  //Package Information Get Function Ends

  //verify OTP
  verifyOTP() async {
    setState(() {
      otpError = '';
    });
    await checkInternet().then((value) async => {
          if (value == true)
            {
              if (loginForm.currentState!.validate())
                {
                  await LoginController()
                      .verifyOTP(emailController.text, otpController.text,
                          iconName, context, currentScreen)
                      .then((value) async {
                    if (value['message'] == 'Connection Error') {
                      context.pushNamed("/noInternet");
                      return;
                    }
                    if (value['status']) {
                      await logDetails();
                      btnVerifyController.success();
                      Future.delayed(const Duration(milliseconds: 1000))
                          .then((value) async => {
                                existingUser =
                                    await storage.read(key: 'existing_user'),
                                if (int.tryParse(existingUser!) != 0)
                                  {
                                    setState(() => {
                                          otpSent = false,
                                          otpController.clear(),
                                          timer?.cancel(),
                                          resendOtpTime = 0
                                        }),
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode()),
                                    context.pushNamed("/"),
                                    //to create new focus node and assign focus to that node to avoid showing keyboard while screen navigation
                                  }
                                else
                                  {
                                    context
                                        .pushNamed('/studentEnquiry', params: {
                                      "verified": iconName,
                                      "user_id": emailController.text,
                                      "existing_otp": otpController.text
                                    }),
                                    setState(() => {
                                          otpSent = false,
                                          otpController.clear(),
                                          timer?.cancel(),
                                          resendOtpTime = 0
                                        }),
                                  }
                              });
                    } else {
                      setState(() {
                        otpError = value.containsKey('message')
                            ? value['message']
                            : 'Invalid OTP';
                      });
                      loginForm.currentState!.validate();
                      btnVerifyController.error();
                      Future.delayed(const Duration(milliseconds: 1000))
                          .then((value) async {
                        btnVerifyController.reset();
                      });
                    }
                  }),
                }
              else
                {
                  btnVerifyController.error(),
                  Future.delayed(const Duration(milliseconds: 1000))
                      .then((value) => {
                            btnVerifyController.reset(),
                          }),
                }
            }
          else
            {
              btnVerifyController.error(),
              Future.delayed(const Duration(milliseconds: 1000))
                  .then((value) => {
                        btnVerifyController.reset(),
                      }),
              messageFlushBar(context),
            }
        });
  }

  //show account list starts
  showAccountList(type) async {
    bool accountSelected = true;
    if (type == 'mobile') {
      String? number = await AccountPicker.phoneHint();
      inputType = TextInputType.number;
      if (number != null) {
        number = number.replaceAll('+91', '');
        emailController.text = email = number.toString();
      } else {
        accountSelected = false;
      }
    } else {
      EmailResult? emailResult = await AccountPicker.emailHint();
      inputType = TextInputType.emailAddress;
      if (emailResult != null) {
        emailController.text = email = emailResult.email.toString();
      } else {
        accountSelected = false;
      }
    }
    setState(() {
      accountPicked = true;
      email;
      inputType;
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!accountSelected) accountField.requestFocus();
    });
  }

  //show account list ends

  //get install referrer
  Future<void> initReferrerDetails() async {
    //only works for android only
    String referrerDetailsString;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;
      referrerDetailsString = referrerDetails.toString();
    } catch (e) {
      referrerDetailsString = '';
    }
    if (referrerDetailsString.contains('utm_campaign')) {
      try {
        referrerDetailsString =
            referrerDetailsString.split('utm_campaign=')[1].split(',')[0];
      } catch (e) {
        referrerDetailsString = '';
      }
    } else {
      referrerDetailsString = '';
    }
    await storage.write(key: 'referral_code', value: referrerDetailsString);
  }

  logDetails() async {
    appVersionError = '';
    var logResult = await NetworkAPI().logAPI();
    if (!logResult['status']) {
      if (logResult.containsKey('message')) {
        appVersionError = logResult['message'];
        messageFlushBar(context, logResult['message']);
        Future.delayed(const Duration(seconds: 2), () async {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          OpenStore.instance.open(
            androidAppBundleId:
                packageInfo.packageName, // Android app bundle package name
          );
        });
      }
    }
    if (mounted) {
      setState(() {
        appVersionError;
      });
    }
  }

/*  //Google Sign In Start
  signInWithGoogle() async {
    print("googleSignIn $googleSignIn");
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      print(googleSignInAccount!.displayName);
      print(googleSignInAccount.id);
      print(googleSignInAccount.serverAuthCode);
      //print(googleSignInAccount.idToken);
      print(googleSignInAccount.email);
      print(googleSignInAccount.photoUrl);

    GoogleSignInAuthentication signInAuthentication =
        await googleSignInAccount.authentication;

      print(signInAuthentication.idToken);

  }
  //Google Sign In Ends

  //Facebook Sign In Starts
  signInWithFacebook() async {
    final accessToken = await facebookAuth.accessToken;
    print(accessToken);
    if (accessToken != null) {
      userData = await facebookAuth.getUserData(
        fields: facebookUserField,
      );
    } else {
      final LoginResult result =
          await facebookAuth.login(permissions: facebookPermission);
      if (result.status == LoginStatus.success) {
        userData = await facebookAuth.getUserData();
      }
    }
  }
  //Facebook Sign In Ends
  //
  // Linkedin Sign In Starts
  signInWithLinkedin() async {
    print("authorizationCode232323");
    print({
      "code":authorizationCode,
      "state":state
    });
    if (authorizationCode != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LinkedInUserWidget(
            redirectUrl: redirectUrl,
            clientId: clientId,
            destroySession: false,
            clientSecret: clientSecret,
            projection: const [
              ProjectionParameters.id,
              ProjectionParameters.localizedFirstName,
              ProjectionParameters.localizedLastName,
              ProjectionParameters.firstName,
              ProjectionParameters.lastName,
              ProjectionParameters.profilePicture,
            ],

            onGetUserProfile: (UserSucceededAction linkedInUser) async {

              print('Access token ${linkedInUser.user.token.accessToken!}');
              print(
                  'First name: ${linkedInUser.user.firstName!.localized!.label!}');
              print(
                  'Last name: ${linkedInUser.user.lastName!.localized!.label!}');
              print('Last name: ${linkedInUser.user.email!}');
              print({
                "code":authorizationCode,
                "state":state
              });
              Navigator.pop(context);
            },
            onError: (UserFailedAction e) {
              print('Error111: ${e.toString()}');
              print(e.toString());
              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LinkedInUserWidget(
            redirectUrl: redirectUrl,
            clientId: clientId,
            clientSecret: clientSecret,
            projection: const [
              ProjectionParameters.id,
              ProjectionParameters.localizedFirstName,
              ProjectionParameters.localizedLastName,
              ProjectionParameters.firstName,
              ProjectionParameters.lastName,
              ProjectionParameters.profilePicture,
            ],

            onGetUserProfile: (UserSucceededAction linkedInUser) async {

              print('Access token ${linkedInUser.user.token.accessToken!}');
              print(
                  'First name: ${linkedInUser.user.firstName!.localized!.label!}');
              print(
                  'Last name: ${linkedInUser.user.lastName!.localized!.label!}');
              print('Email: ${linkedInUser.user.email!.elements!.single.handleDeep!.emailAddress}');
              print('UserId: ${linkedInUser.user.userId!}');
              print('First Name Local: ${linkedInUser.user.localizedFirstName}');
              print('Last Name Local: ${linkedInUser.user.localizedLastName}');
              print({
                "code":authorizationCode,
                "state":state
              });
              Navigator.pop(context);
            },
            onError: (UserFailedAction e) {
              print('Error111: ${e.toString()}');
              print(e.toString());
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }
  //Linkedin Sign In Ends*/

//enquiry form
// enquiryForm() {
//   return showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) =>
//         StatefulBuilder(builder: (context, setState) {
//       Size size = MediaQuery.of(context).size;
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0),
//           side: const BorderSide(width: 2, color: Colors.transparent),
//         ),
//         contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
//         content: SingleChildScrollView(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             chatBubbleSender(
//                 enquiryQuestions[0].keys.first, iterator == 0, size),
//             if (iterator >= 1) ...[
//               chatBubbleStudent(
//                   enquiryQuestions[0].values.first, false, size),
//               chatBubbleSender(
//                   enquiryQuestions[1].keys.first, iterator == 1, size),
//             ],
//             if (iterator >= 2) ...[
//               chatBubbleStudent(
//                   enquiryQuestions[1].values.first, false, size),
//               chatBubbleSender(
//                   enquiryQuestions[2].keys.first, iterator == 2, size),
//             ],
//             //mobile number
//             if (iterator >= 3) ...[
//               chatBubbleStudent(
//                   enquiryQuestions[2].values.first, false, size),
//               chatBubbleSender(
//                   '${enquiryQuestions[3].keys.first}${enquiryQuestions[2].values.first}',
//                   iterator == 3,
//                   size),
//             ],
//             //email id
//             if (iterator >= 4) ...[
//               chatBubbleStudent(
//                   enquiryQuestions[3].values.first, false, size),
//               chatBubbleSender(
//                   enquiryQuestions[4].keys.first, iterator == 4, size),
//             ],
//             //email id otp verify
//             if (iterator >= 5) ...[
//               chatBubbleStudent(
//                   enquiryQuestions[4].values.first, false, size),
//               chatBubbleSender(
//                   '${enquiryQuestions[5].keys.first} ${enquiryQuestions[4].values.first}',
//                   iterator == 5,
//                   size),
//             ],
//             //email id otp msg show
//             if (iterator >= 6) ...[
//               chatBubbleStudent(
//                   enquiryQuestions[5].values.first, false, size),
//             ],
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: size.width / 1.5,
//                   child: TextFormField(
//                     autofocus: true,
//                     controller: enquiryTextController,
//                     focusNode: enquiryFocus,
//                     inputFormatters: [
//                       [2, 3].contains(iterator)
//                           ? FilteringTextInputFormatter.digitsOnly
//                           : FilteringTextInputFormatter.singleLineFormatter
//                     ],
//                     maxLength: inputLength,
//                     keyboardType: enquiryInputType,
//                     cursorColor: colorCode.withOpacity(0.8),
//                     decoration: InputDecoration(
//                         focusedBorder: UnderlineInputBorder(
//                       borderSide:
//                           BorderSide(color: colorCode.withOpacity(0.8)),
//                     )),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 10, top: 10),
//                   child: sendingOTP
//                       ? Icon(Icons.hourglass_bottom_outlined,
//                           color: colorCode.withOpacity(0.8), size: 16)
//                       : InkWell(
//                           child: Icon(Icons.send_outlined,
//                               color: colorCode.withOpacity(0.8), size: 16),
//                           onTap: () async {
//                             if (enquiryTextController.text.trim() != '') {
//                               bool nextQuestion = true;
//                               //check number OTP
//                               if ([3, 5].contains(iterator)) {
//                                 if (int.tryParse(
//                                         enquiryTextController.text) !=
//                                     otp) {
//                                   errorMessageFlushBar(context, 'Invalid OTP',
//                                       Icons.error_outline_outlined);
//                                   nextQuestion = false;
//                                 }
//                               }

//                               //check email
//                               if (iterator == 4) {
//                                 if (!isEmailValid(
//                                     enquiryTextController.text)) {
//                                   errorMessageFlushBar(
//                                       context,
//                                       'Invalid Email Id',
//                                       Icons.error_outline_outlined);
//                                   nextQuestion = false;
//                                 }
//                               }

//                               //change keyboard type for mobile number & OTP input
//                               if ([1, 2, 3, 4].contains(iterator) &&
//                                   nextQuestion) {
//                                 enquiryFocus.unfocus();
//                                 enquiryInputType = [3].contains(iterator)
//                                     ? TextInputType.text
//                                     : TextInputType.phone;
//                                 Future.delayed(
//                                     const Duration(milliseconds: 50), () {
//                                   enquiryFocus.requestFocus();
//                                 });
//                                 if ([2, 4].contains(iterator)) {
//                                   setState(() {
//                                     sendingOTP = true;
//                                   });
//                                   nextQuestion = await sendOTP(
//                                       enquiryTextController.text);
//                                   if (!nextQuestion) {
//                                     errorMessageFlushBar(
//                                         context,
//                                         'Some error occurred! Try again later',
//                                         Icons.error_outline_outlined);
//                                   }
//                                 }
//                               }
//                               setState(
//                                 () {
//                                   sendingOTP = false;
//                                   enquiryInputType;
//                                   if ([1, 2, 3, 4].contains(iterator)) {
//                                     inputLength = iterator == 1
//                                         ? 10
//                                         : [2, 4].contains(iterator)
//                                             ? 4
//                                             : 35;
//                                   }
//                                   if (nextQuestion) {
//                                     enquiryQuestions[iterator].update(
//                                         enquiryQuestions[iterator].keys.first,
//                                         (value) =>
//                                             enquiryTextController.text);
//                                     iterator++;
//                                   }
//                                   enquiryTextController.text = '';
//                                 },
//                               );
//                             } else {
//                               errorMessageFlushBar(
//                                   context,
//                                   'Fill a valid value',
//                                   Icons.error_outline_outlined);
//                             }
//                           }),
//                 ),
//               ],
//             )
//           ]),
//         ),
//       );
//     }),
//   );
// }

// //sendOTP
// sendOTP(userId) async {
//   var response = await LoginController().enquiryOTP(context, userId);
//   if (response['otpStatus']) {
//     response = response['data'];
//     setState(() {
//       otp = response['data'][0];
//     });
//     return true;
//   } else {
//     return false;
//   }
// }

// //chat bubble sender design
// chatBubbleSender(content, tail, size) {
//   return SizedBox(
//     width: size.width / 1.5,
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: BubbleSpecialThree(
//         text: content,
//         color: colorCode.withOpacity(0.8),
//         tail: tail,
//         textStyle: const TextStyle(color: Colors.white, fontSize: 16),
//       ),
//     ),
//   );
// }

// //chat bubble sender design
// chatBubbleStudent(content, tail, size) {
//   return SizedBox(
//     width: size.width / 1.5,
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: BubbleSpecialThree(
//         text: content,
//         color: const Color(0xFFE8E8EE),
//         tail: tail,
//         isSender: false,
//       ),
//     ),
//   );
// }
}
//Login Screen Ends
