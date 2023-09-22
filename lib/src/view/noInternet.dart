// ignore_for_file: use_build_context_synchronously, file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../common/theme.dart';
import '../../common/connection.dart';
import '../../common/internetCheck.dart';
import '../../constants.dart';
import '../../main.dart';
import 'login.dart';

//No Internet Connection Screen Starts
class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  //Variable Declaration Starts
  bool isNewOnline = true;

  //Variable Declaration Ends

  //Initialize State Starts
  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  //Initialize State Ends

  //Main Widget Starts
  @override
  Widget build(BuildContext context) {
    //Widget Return Starts
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: (!isNewOnline)
              ? Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_outlined, size: 100),
                      const Text(
                        "Oops! No Internet Connection",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 60.0,
                            right: 50.0,
                            top: 10.0,
                            bottom: 10.0,
                          ),
                          child: Text(
                            "Make sure wifi or cellular data is turned on and then try again",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final isSocketConnect = await hasNetwork();
                          if (isSocketConnect) {
                            Router.neglect(context, () {
                              bottomIndex = 0;
                              context.pushNamed('/');
                            });
                          } else {
                            return;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorCode,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Try Again',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Container(
                      color: Colors.transparent,
                      child: const CircularProgressIndicator(
                        color: colorCode,
                      ))),
        ));
  }

//Main Widget Ends

  //Get Screen initializing data function starts
  checkInternet() async {
    try {
      final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
      bottomIndex = 0;
      await storage.write(key: 'bottom_index', value: "0");
      final isSocketConnect = await hasNetwork();
      if (isOnline && isSocketConnect) {
        if (token != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginLive()),
          );
        }
        setState(() {
          isNewOnline = isOnline;
        });
      } else {
        setState(() {
          isNewOnline = false;
        });
      }
    } on HandshakeException catch (_) {
      setState(() {
        isNewOnline = false;
      });
    } on SocketException catch (_) {
      // make it explicit that a SocketException will be thrown if the network connection fails
      setState(() {
        isNewOnline = false;
      });
      // rethrow;
    } catch (e) {
      if (mounted) {
        setState(() {
          isNewOnline = false;
        });
      }
    }
  }
//Get Screen initializing data function Ends
}
//No Internet Connection Screen Ends
