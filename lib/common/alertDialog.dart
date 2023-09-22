// ignore_for_file: file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

//OTP Dialog Screen Starts
otpDialog(context, loadingStatus) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (BuildContext builderContext, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(width: 2, color: Colors.transparent),
          ),
          child: ([7, 9].contains(loadingStatus))
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(padding: EdgeInsets.all(15)),
                    const CircularProgressIndicator(
                      color: colorCode,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Text(
                          loadingStatus == 7 ? "Downloading..." : "Loading..."),
                    ),
                  ],
                )
              : const Center(),
        ),
      );
    },
  );
}
//OTP Dialog Screen Ends

//Dialog With Single button Ok Starts
dialogWithOkButton(context, title) {
  return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext builderContext, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(width: 2, color: Colors.transparent),
            ),
            content: Text(title),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: colorCode,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(width: 2, color: colorCode),
                  ),
                ),
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Text(
                  'Ok',
                  style: fontStyle1,
                ),
              ),
            ],
          ),
        );
      });
}
//Dialog With Single button Ok Ends

//Dialog With Single button Ok Starts
dialogWithOkActionButton(context, title, courseList, onPressed) {
  return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext builderContext, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(width: 2, color: Colors.transparent),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 8),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF0F1113),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (courseList != null)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: courseList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 5, 8),
                          child: Text(
                            "${index + 1}. ${courseList[index].text}",
                            style: const TextStyle(
                              color: Color(0xFF0F1113),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(width: 1, color: colorCode),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          '  Cancel  ',
                          style: fontStyle7,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: colorCode,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(width: 1, color: colorCode),
                          ),
                        ),
                        onPressed: onPressed,
                        child: Row(
                          children: [
                            Text(
                              '  Proceed  ',
                              style: fontStyle1,
                            ),
                            const Icon(Icons.arrow_right_alt_rounded,
                                color: Colors.white)
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
}
//Dialog With Single button Ok Ends

//Exit Dialog Start
showExitPopup(context) async {
  return await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext builderContext, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
            scale: curve,
            child: AlertDialog(
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: const BorderSide(width: 2, color: Colors.transparent),
              ),
              content: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Do you want to exit ?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("No",
                              style: TextStyle(
                                  color: colorCode,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            if (Platform.isAndroid) {
                              SystemNavigator.pop();
                            }
                            if (Platform.isIOS) {
                              exit(0);
                            }
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                                color: colorCode, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
      });
}
//Exit Dialog Ends

//Transparent Background Dialog Starts
transparentDialog(context) async {
  Size size = MediaQuery.sizeOf(context);
  return await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext builderContext, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
            scale: curve,
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(width: 2, color: Colors.transparent),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  content: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: colorCode,
                      ),
                    ),
                  ));
            }));
      });
}
//Transparent Background Dialog Ends
