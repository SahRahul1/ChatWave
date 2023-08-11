import 'dart:io';
import 'package:chatwave/screens/login_screen.dart';
import 'package:chatwave/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'username': user.displayName,
            'uid': user.uid,
            'profilePhoto': user.photoURL,
          });
        }
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      res = false;
    }
    on SocketException catch(e){
      showSnackBar(context, "Internet Error!!");
    }
    return res;
  }
  void signOut(BuildContext context) async {
    try {
      GoogleSignIn().signOut;
      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }),
      );
    } catch (e) {
      print(e);
    }
  }
}