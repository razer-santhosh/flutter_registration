// ignore_for_file: file_names, use_build_context_synchronously, unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

//App Bar For all pages Widget Starts
class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color bgColor;
  final Widget? title;
  final AppBar appBar;
  final Widget? leading;
  final List<Widget>? actionWidgets;

  const BaseAppBar({
    Key? key,
    this.title,
    required this.appBar,
    this.leading,
    this.actionWidgets,
    required this.bgColor,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);

  @override
  State<BaseAppBar> createState() => _BaseAppBarState();
}

class _BaseAppBarState extends State<BaseAppBar> {
  //Initialize The State Starts
  @override
  void initState() {
    super.initState();
    // getData();
  }
  //Initialize The State Ends

  @override
  void dispose() {
    super.dispose();
  }

  //Main Widget Starts
  @override
  Widget build(BuildContext context) {
    //Widget Return Starts
    // if (widget.actionWidgets != null) {
    return AppBar(
      surfaceTintColor: (widget.bgColor != null) ? widget.bgColor : colorCode,
      backgroundColor: (widget.bgColor != null) ? widget.bgColor : colorCode,
      title: widget.title,
      leading: widget.leading,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      automaticallyImplyLeading: false,
      iconTheme: const IconThemeData(color: colorCode),
      actions: widget.actionWidgets,
      centerTitle: true,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: colorCode, statusBarIconBrightness: Brightness.light),
    );
    // } else {
    // return AppBar(
    //   elevation: 0,
    //   leadingWidth: (widget.leading != null) ? 50 : 140,
    //   centerTitle: true,
    //   automaticallyImplyLeading: false,
    //   systemOverlayStyle: const SystemUiOverlayStyle(
    //       statusBarColor: colorCode,
    //       statusBarIconBrightness: Brightness.light),
    //   leading: GestureDetector(
    //     onTap: () async {
    //       Router.neglect(context, () {
    //         context.pushNamed('/');
    //       });
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 5),
    //       child: SvgPicture.asset(logoLogin, fit: BoxFit.cover),
    //     ),
    //   ),
    //   backgroundColor: Colors.white,
    //   title: widget.title,
    //   actions: [
    //     Padding(
    //       padding: const EdgeInsets.only(right: 10),
    //       child: Row(
    //         children: [
    //           GestureDetector(
    //             onTap: () async {
    //               setState(() {
    //                 bottomIndex = baseSideMenu
    //                     .where((e) => e.route == "/profile")
    //                     .toList()
    //                     .first
    //                     .bottomIndex;
    //               });
    //               await storage.write(
    //                   key: 'bottom_index', value: bottomIndex.toString());
    //               context.pushNamed('/profile');
    //             },
    //             child: SizedBox(
    //               width: MediaQuery.of(context).size.width * 0.32,
    //               child: userName != null
    //                   ? Text(
    //                       toBeginningOfSentenceCase('$userName').toString(),
    //                       overflow: TextOverflow.clip,
    //                       textAlign: TextAlign.end,
    //                       style: const TextStyle(
    //                         color: Colors.black,
    //                       ))
    //                   : const Text(""),
    //             ),
    //           ),
    //           const SizedBox(width: 15),
    //           GestureDetector(
    //             onTap: () async {
    //               setState(() {
    //                 bottomIndex = baseSideMenu
    //                     .where((e) => e.route == "/profile")
    //                     .toList()
    //                     .first
    //                     .bottomIndex;
    //               });
    //               await storage.write(
    //                   key: 'bottom_index', value: bottomIndex.toString());
    //               context.pushNamed('/profile');
    //             },
    //             child: encodedImage != null
    //                 ? CircleAvatar(
    //                     backgroundColor: Colors.white,
    //                     radius: 20.0,
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                         shape: BoxShape.circle,
    //                         image: DecorationImage(
    //                             image: MemoryImage(encodedImage),
    //                             fit: BoxFit.fill),
    //                       ),
    //                     ),
    //                   )
    //                 : CircleAvatar(
    //                     radius: 20.0,
    //                     backgroundColor:
    //                         const Color.fromARGB(255, 211, 205, 205)
    //                             .withOpacity(0.7),
    //                     child: Text(
    //                       userName[0],
    //                       style: const TextStyle(fontSize: 20),
    //                     ),
    //                   ),
    //           ),
    //           IconButton(
    //               onPressed: () async {
    //                 showDialog(
    //                     context: context,
    //                     barrierDismissible: false,
    //                     builder: (BuildContext builderContext) {
    //                       return Dialog(
    //                           surfaceTintColor: Colors.white,
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(20.0),
    //                             side: const BorderSide(
    //                                 width: 2, color: Colors.transparent),
    //                           ),
    //                           child: const Column(
    //                             mainAxisSize: MainAxisSize.min,
    //                             children: [
    //                               Padding(padding: EdgeInsets.all(15)),
    //                               CircularProgressIndicator(
    //                                 color: colorCode,
    //                               ),
    //                               Padding(
    //                                   padding: EdgeInsets.only(bottom: 10)),
    //                               Text("Logging Out..."),
    //                               Padding(
    //                                   padding: EdgeInsets.only(bottom: 10)),
    //                             ],
    //                           ));
    //                     });
    //                 Future.delayed(const Duration(milliseconds: 100),
    //                     () async {
    //                   await LoginController().logout().then((val) {
    //                     Navigator.of(context, rootNavigator: true).pop();
    //                     context.pushNamed("/");
    //                   });
    //                 });
    //               },
    //               icon: const Icon(Icons.logout_outlined, color: colorCode))
    //         ],
    //       ),
    //     ),
    //   ],
    // );
    // }
    //Widget Return Ends
  }

  //Main Widget Starts

  //Get Data to initialize the app bar Function Starts
  // getData() async {
  //   token = await storage.read(key: 'token');
  //   userId = await storage.read(key: 'user_id');
  //   userName = await storage.read(key: 'username');
  //   profilePicture = await storage.read(key: 'profile_picture');
  //   if (profilePicture != null) {
  //     final decodeString = base64Decode(profilePicture.split(',').last);
  //     encodedImage = decodeString;
  //   }

  //   if (mounted) {
  //     setState(() {
  //       token;
  //       userName;
  //       colorCode;
  //       userId;
  //       encodedImage;
  //     });
  //   }
  // }
  //Get Data to initialize the app bar Function Ends
}
//App Bar For all pages Widget Ends
