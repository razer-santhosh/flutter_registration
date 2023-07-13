import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../common/validation.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

const storage = FlutterSecureStorage();
final loginForm = GlobalKey<FormState>();
bool hidePassword = true, emailValid = false, userNameValid = false;
TextEditingController usernameController = TextEditingController(),
    emailIdController = TextEditingController(),
    passwordController = TextEditingController();
RoundedLoadingButtonController createAccount = RoundedLoadingButtonController();

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double width = size.width;
    double height = size.height;
    return Scaffold(
      backgroundColor: const Color(0XFF3a5db9),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.05),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Flogo%2Fsignup.png?alt=media&token=c09e67aa-d7f9-4b6f-8195-8cde196f9a93',
                      width: width * 0.8,
                      height: height * 0.4,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: const Text('Sign Up',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: width * 0.1, vertical: 5),
              child: Form(
                  key: loginForm,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      inputBox(width, 'User Name', usernameController),
                      inputBox(width, 'Email ID', emailIdController),
                      inputBox(width, 'Password', passwordController, true),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: RoundedLoadingButton(
                          controller: createAccount,
                          successColor: Colors.green,
                          onPressed: () async {
                            if (loginForm.currentState!.validate()) {
                              await storage.write(
                                  key: 'username',
                                  value: usernameController.text);
                              await storage.write(
                                  key: 'email', value: emailIdController.text);
                              await storage.write(
                                  key: 'password',
                                  value: passwordController.text);
                              createAccount.success();
                              Future.delayed(const Duration(seconds: 1), (() {
                                createAccount.reset();
                                Navigator.pushNamed(context, '/business');
                              }));
                            } else {
                              createAccount.error();
                              Future.delayed(const Duration(seconds: 1), (() {
                                createAccount.reset();
                              }));
                            }
                          },
                          color: const Color(0XFF5f88d8),
                          borderRadius: 10,
                          child: const Center(
                            child: Text('CREATE ACCOUNT',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Divider(
                              height: 10,
                              thickness: 3,
                              color: Color(0XFF5f88d8),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text('or',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                            child: Divider(
                              height: 10,
                              thickness: 3,
                              color: Color(0XFF5f88d8),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sign Up With',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10)),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Ficon%2FGicon.png?alt=media&token=77bcfaa4-662d-4503-8a0a-f31adadc9b57',
                                  height: 20),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Ficon%2FFicon.png?alt=media&token=01d5ecea-1d57-4058-b958-db340ebb877f',
                                  height: 20),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Ficon%2FLicon.png?alt=media&token=456aa250-b8d1-4fb0-8fa1-cddc636a7e1d',
                                  height: 20),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/oneclx.appspot.com/o/asset%2Ficon%2FTicon.png?alt=media&token=9ea17275-989d-48c4-b982-5a1cb9866135',
                                  height: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  inputBox(double width, String hintText, TextEditingController textController,
      [showEyeIcon = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: textController,
        maxLength: textController == emailIdController ? 40 : 20,
        decoration: InputDecoration(
            isDense: true,
            counterText: '',
            hintText: hintText,
            hintStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
            errorStyle: const TextStyle(color: Colors.white),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
                gapPadding: 0, borderRadius: BorderRadius.circular(50)),
            prefixText: '    ',
            suffixIcon: showEyeIcon
                ? InkWell(
                    onTap: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    child: Opacity(
                        opacity: 0.4,
                        child: hidePassword
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility)),
                  )
                : null),
        obscureText: showEyeIcon && hidePassword,
        obscuringCharacter: '*',
        onChanged: (value) async {
          if (textController == usernameController) {
            userNameValid = await Validation().validateUserName(value);
            setState(() {
              userNameValid;
            });
          } else if (textController == emailIdController) {
            emailValid = await Validation().validateEmail(value);
            setState(() {
              emailValid;
            });
          }
        },
        validator: (value) {
          if (textController == usernameController) {
            if (userNameValid) {
              return null;
            } else {
              return 'Enter a valid username';
            }
          } else if (textController == emailIdController) {
            if (emailValid) {
              return null;
            } else {
              return 'Enter a valid email ID';
            }
          } else if (textController == passwordController) {
            if (value != '' && value!.length > 3) {
              return null;
            } else {
              return 'Enter atleast 4 characters';
            }
          }
          return null;
        },
      ),
    );
  }
}
