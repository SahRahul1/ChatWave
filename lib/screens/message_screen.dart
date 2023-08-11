import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/screens/search_screen.dart';
import 'package:chatwave/widgets/contacts_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class MessageScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MessageScreen(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController SearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
          backgroundColor: appBarColor,
          titleSpacing: 0,
          title: const Text("Message")),
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )),
        //margin: EdgeInsets.all(20),
        padding: const EdgeInsets.only(top: 20),
        child: ContactsList(
            userModel: widget.userModel, firebaseUser: widget.firebaseUser, isAll: true,),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return SearchScreen(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser,
                  next: false);
            },
          ));
        },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.person_search_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
