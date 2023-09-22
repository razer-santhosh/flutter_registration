// ignore_for_file: file_names, unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../constants.dart';
import '../main.dart';

class PaymentDialog extends StatefulWidget {
  final String title;
  final String? descriptions, submitText, cancelText, status;
  final Image? img;
  final IconData? icons;
  final Color? color;
  final VoidCallback? onRefreshData;

  const PaymentDialog(
      {Key? key,
      required this.title,
      this.descriptions,
      this.submitText,
      this.cancelText,
      this.status,
      this.color,
      this.icons,
      this.img,
      this.onRefreshData})
      : super(key: key);

  @override
  PaymentDialogState createState() => PaymentDialogState();
}

class PaymentDialogState extends State<PaymentDialog>
    with TickerProviderStateMixin {
  final RoundedLoadingButtonController btnPayController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(cnt) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(left: 20, top: 25, right: 20, bottom: 20),
            margin: const EdgeInsets.only(top: 25, left: 0, right: 0),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: widget.color ?? colorCode),
                ),
                if (widget.descriptions != null) ...[
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.descriptions!,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(
                  height: 22,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (widget.submitText != null) ...[
                        SizedBox(
                          width: width * 0.2,
                          height: currentScreen == "mobile"
                              ? width * 0.12
                              : width * 0.085,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              backgroundColor: MaterialStateProperty.all(
                                  widget.color ?? colorCode),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            onPressed: widget.onRefreshData ??
                                () {
                                  if (widget.submitText == "OK") {
                                    btnPayController.reset();
                                    Navigator.pop(context);
                                  }
                                },
                            child: Text(widget.submitText!, style: fontStyle1),
                          ),
                        ),
                      ],
                      if (widget.cancelText != null) ...[
                        SizedBox(
                            width: width * 0.2,
                            height: currentScreen == "mobile"
                                ? width * 0.12
                                : width * 0.085,
                            child: OutlinedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(widget.cancelText!,
                                    style: fontStyle7))),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.icons != null)
            Positioned(
                left: 20,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: widget.color ?? colorCode,
                  radius: 25,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: Center(
                          child: Icon(
                        widget.icons,
                        color: Colors.white,
                      ))),
                ))
        ],
      ),
    );
  }
}
