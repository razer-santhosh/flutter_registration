// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import '../../main.dart';

//Privacy Policy Common Screen Starts
class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  //Main Widget Starts
  @override
  Widget build(BuildContext context) {
    //Variable Declaration Inside The Widget Starts
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    //Variable Declaration Inside The Widget Ends
    //Widget Return Starts
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                child: BackButton(
                    color: colorCode,
                    onPressed: () async => {
                          Navigator.pop(context),
                        }),
              ),
            ),
            Center(
              child: SizedBox(
                height: height * 0.15,
                width: width * 0.7,
                child: SvgPicture.asset(
                  logoLogin,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              height: currentScreen == 'mobile' ? height * 0.7 : height * 0.75,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Privacy Policy',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: colorCode,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'CADD Centre  considers the security and protection of your personal data and information important. Therefore, CADD Centre  operates its website in compliance with applicable laws on data privacy protection and data security. \n\nBelow, we provide information on the types of data we collect through all CADD Centre  websites, the purpose we use such data, and parties with which we share such data, where applicable.',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Collected Data and Purpose of Processing',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: colorCode,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'We only collect personal data (e.g. Names, Country, Location, Telephone/ Mobile, Email ID, etc.) with regard to operating our website only when you voluntarily provided this data to us (e.g. through registration, contact inquiries, surveys, etc.) and we are entitled to use or process such data by virtue of permission granted by you on the basis of statutory provision. \n\nAs a general rule, we only use such data exclusively for the purpose for which the data was disclosed to us by you, such as to answer your inquiries, grant you access, process your orders, etc.',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Data Sharing',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: colorCode,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'For the purpose indicated above, insofar, as you have provided your consent, or when we are legally entitled to do so, we will share your personal data with the subsidiaries of CADD Centre , wherever required. \n\nIn connection with the operation of this website and the services offered CADD Centre  works as a network of all its subdivisions such as DreamZone, Synergy, CADD Centre, CCUBE, IID, Skillease, One Channel, CADD at School and Dream Flower. \n\nThese Strategic Business units are located in and outside India, possibly, all over the Asia, in this regard; the applicability of data secrecy and protection laws may vary. In such cases, CADD Centre  takes measures to ensure an appropriate level of data privacy and protection. \n\nData is shared only in compliance with the applicable laws and regulations. We do not sell or otherwise market your personal data to third parties.',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Questions, Comments and Amendments',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: colorCode,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'CADD Centre  will respond to all the legitimate requests for information, and wherever applicable to correct, amend or delete your personal data. If you wish to make such a request or if you have questions or comments about this Data Privacy Policy, please click on “Contact Us” and feel free to share. \n\nThis Data Privacy policy is updated on a regular basis. You will find the date of the last update on this page.',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    //Widget Return Ends
  }
//Main Widget Ends
}
//Privacy Policy Common Screen Ends
