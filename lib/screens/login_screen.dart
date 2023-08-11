import 'package:chatwave/resources/FirebaseHelper.dart';
import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/resources/auth_methods.dart';
import 'package:chatwave/screens/home_screen.dart';
import 'package:chatwave/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/login.gif',
            ),
            const Text(
              'ChatWave',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0, // shadow blur
                      color: Colors.blueGrey, // shadow color
                      offset: Offset(1, 1), // how much shadow will be shown
                    ),
                  ],
                  color: ChatWave),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        decoration: const BoxDecoration(
          color: appBarColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: const [
                Text(
                  'Welcome',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                Text(
                  'Get stated with your account',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: button,
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: Image.asset(
                  'assets/images/google-logo.png',
                  height: 30,
                  width: 30,
                ),
                label: const Text(
                  "Sign In with Google",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                onPressed: () async {
                  bool res = await _authMethods.signInWithGoogle(context);
                  if (res) {
                    User? currentUser = FirebaseAuth.instance.currentUser;
                    UserModel? thisUserModel =
                        await FirebaseHelper.getUserModelById(currentUser!.uid);
                    if (thisUserModel != null) {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen(
                              userModel: thisUserModel,
                              firebaseUser: currentUser);
                        },
                      ));
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}
