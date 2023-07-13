// ignore_for_file: file_names

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../common/constants.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({super.key});

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

final TextEditingController businessNameController = TextEditingController();
String? businessType;
final businessForm = GlobalKey<FormState>();
bool formValid = true;

class _BusinessProfileState extends State<BusinessProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double width = size.width;
    double height = size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onPanUpdate: (drag) {
          if (drag.delta.dx < 0) {
            if (businessForm.currentState!.validate()) {
              Navigator.pushNamed(context, '/contact');
            } else {
              formValid = false;
            }
            setState(() {
              formValid;
            });
          }
        },
        child: Container(
          padding:
              EdgeInsets.only(top: formValid ? height * 0.1 : height * 0.04),
          height: height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xFF7495d8),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Ficon%2FBP.png?alt=media&token=691c22f3-68af-4df3-a66c-97d23e551355'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text('Business Profile', style: headingText),
                ),
                const Text('0 of 6 Completed', style: smallText),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: LinearPercentIndicator(
                    alignment: MainAxisAlignment.center,
                    barRadius: const Radius.circular(10),
                    width: width * 0.9,
                    lineHeight: 16,
                    percent: 0.2,
                    backgroundColor: appThemeColor,
                    progressColor: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CREATE BUSINESS PROFILE', style: subTitle),
                      SizedBox(height: 20),
                      Text('Start Building Your\n  Business Profile',
                          style: normalText),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Form(
                    key: businessForm,
                    child: Column(
                      children: [
                        textBox(width, 'Business Name', businessNameController),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 35),
                          child: DropdownButtonFormField2<String>(
                            value: businessType,
                            items: ['Corporate', 'Hotel', 'Travels']
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (businessForm.currentState!.validate()) {
                                setState(() {
                                  businessType = value;
                                  formValid = true;
                                });
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null) {
                                return 'Select one business type';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                counterText: '',
                                hintText: 'Choose',
                                hintStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w300),
                                errorStyle:
                                    const TextStyle(color: Colors.redAccent),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                enabledBorder: commonInputBorder,
                                focusedBorder: commonInputBorder,
                                errorBorder: commonInputBorder),
                            menuItemStyleData: MenuItemStyleData(
                                selectedMenuItemBuilder: (context, item) {
                              return ListTile(
                                selected: true,
                                selectedColor: appThemeColor,
                                title: businessType != null
                                    ? Text(
                                        businessType!,
                                        style: const TextStyle(
                                            color: appThemeColor),
                                      )
                                    : const Text(""),
                              );
                            }),
                            dropdownStyleData: DropdownStyleData(
                                maxHeight: height * 0.5,
                                width: width * 0.83,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                offset: Offset(width - (width * 1),
                                    -10) // change the position of the drop down
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Flogo%2Fimg1.png?alt=media&token=8aa401b4-5635-451f-af67-3dcd82117797'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Text('SWIPE',
                              style: TextStyle(color: Colors.blueAccent)),
                          const SizedBox(width: 5),
                          Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Flogo%2FRight.png?alt=media&token=6f429db7-33c2-4063-865b-f0f8417a4acc'),
                        ],
                      ),
                    ),
                    Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Flogo%2Fimg2.png?alt=media&token=b8fcb386-3ab4-4f9c-bece-bc3be039c5e5'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  textBox(double width, String hintText, TextEditingController textController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: TextFormField(
        controller: textController,
        maxLength: 20,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            isDense: true,
            counterText: '',
            hintText: hintText,
            hintStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            errorStyle: const TextStyle(color: Colors.redAccent),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            enabledBorder: commonInputBorder,
            focusedBorder: commonInputBorder,
            focusedErrorBorder: commonInputBorder,
            errorBorder: commonInputBorder),
        onChanged: (value) {
          if (businessForm.currentState!.validate()) {
            setState(() {
              businessNameController.text = value;
              formValid = true;
            });
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (textController == businessNameController) {
            if (value != '') {
              return null;
            } else {
              return 'Enter a valid business name';
            }
          }
          return null;
        },
      ),
    );
  }
}
