import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/screens/message_screen.dart';
import 'package:chatwave/screens/search_screen.dart';
import 'package:chatwave/screens/more_screen.dart';
import 'package:chatwave/utils/colors.dart';
import 'package:chatwave/widgets/contacts_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomeScreen(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarColor,
        centerTitle: false,
        title: const Text(
          'ChatWave',
          style: TextStyle(
            fontSize: 22,
            color: grey,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: grey),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchScreen(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                    next: true);
              }));
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: grey),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MoreScreen(
                    userModel: widget.userModel);
              }));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),
          child: ContactsList(
              userModel: widget.userModel, firebaseUser: widget.firebaseUser, isAll: false,),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return MessageScreen(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser);
            },
          ));
        },
        backgroundColor: tabColor,
        child: const Icon(Icons.sms_rounded, color: Colors.white),
      ),
    );
  }
}
