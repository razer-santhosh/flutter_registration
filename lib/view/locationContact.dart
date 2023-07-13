// ignore_for_file: file_names
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../common/constants.dart';

class LocationContact extends StatefulWidget {
  const LocationContact({super.key});

  @override
  State<LocationContact> createState() => _BusinessProfileState();
}

final TextEditingController cityController = TextEditingController(),
    pincodeController = TextEditingController(),
    addressController = TextEditingController(),
    mobilenumberController = TextEditingController();
String? country, state;
final contactForm = GlobalKey<FormState>();
bool formValid = true;

class _BusinessProfileState extends State<LocationContact> {
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
            if (contactForm.currentState!.validate()) {
              formValid = true;
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
              EdgeInsets.only(top: formValid ? height * 0.05 : height * 0.02),
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
                    'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Ficon%2Finfo.png?alt=media&token=574c6342-3ccd-4d9b-91ea-937844c9229c'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text('Location & Contact Info', style: headingText),
                ),
                const Text('1 of 6 Completed', style: smallText),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: LinearPercentIndicator(
                    alignment: MainAxisAlignment.center,
                    barRadius: const Radius.circular(10),
                    width: width * 0.9,
                    lineHeight: 16,
                    percent: 0.4,
                    backgroundColor: appThemeColor,
                    progressColor: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text('ADD BUSINESS LOCATION', style: subTitle),
                ),
                SingleChildScrollView(
                  child: Form(
                    key: contactForm,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 35),
                          child: DropdownButtonFormField2<String>(
                            value: country,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            items: ['India', 'USA', 'China']
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                country = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Select a country';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                counterText: '',
                                hintText: 'Country',
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
                                title: country != null
                                    ? Text(
                                        country!,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 35),
                          child: DropdownButtonFormField2<String>(
                            value: state,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            items: ['TamilNadu', 'Kerala', 'Andhra']
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                state = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Select a state';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                counterText: '',
                                hintText: 'State',
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
                                title: state != null
                                    ? Text(
                                        state!,
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
                        textBox(width, 'City', cityController),
                        textBox(width, 'Pincode', pincodeController),
                        textBox(width, 'Address Line', addressController),
                        textBox(width, 'Mobile Number', mobilenumberController,
                            true)
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
                          Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Flogo%2FLefi.png?alt=media&token=6ce0a918-d370-46ac-8569-13be12e85940'),
                          const SizedBox(width: 5),
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

  textBox(double width, String hintText, TextEditingController textController,
      [showCountry = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textController,
        maxLength: textController == mobilenumberController
            ? 10
            : textController == pincodeController
                ? 6
                : 20,
        textAlign: textController == mobilenumberController
            ? TextAlign.start
            : TextAlign.center,
        keyboardType:
            [mobilenumberController, pincodeController].contains(textController)
                ? TextInputType.number
                : TextInputType.text,
        inputFormatters:
            [mobilenumberController, pincodeController].contains(textController)
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                        textController == mobilenumberController ? 10 : 6),
                  ]
                : [
                    LengthLimitingTextInputFormatter(30),
                  ],
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
            errorBorder: commonInputBorder,
            prefixIcon: showCountry
                ? SizedBox(
                    width: width * 0.22,
                    child: const CountryCodePicker(
                      padding: EdgeInsets.zero,
                      onChanged: print,
                      initialSelection: 'IN',
                      hideMainText: true,
                      alignLeft: true,
                    ),
                  )
                : null),
        validator: (value) {
          if (textController == cityController) {
            if (value != '' && value!.length >= 3) {
              return null;
            } else {
              return 'Enter a valid city name';
            }
          } else if (textController == pincodeController) {
            if (value != '' && value!.length == 6) {
              return null;
            } else {
              return 'Enter a valid pincode';
            }
          } else if (textController == addressController) {
            if (value != '' && value!.length < 5) {
              return null;
            } else {
              return 'Enter a valid address';
            }
          } else if (textController == mobilenumberController) {
            if (value != '' && value!.length == 10) {
              return null;
            } else {
              return 'Enter a valid mobile number';
            }
          }
          return null;
        },
      ),
    );
  }
}
