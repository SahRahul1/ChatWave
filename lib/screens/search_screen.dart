import 'package:chatwave/models/chat_room_models.dart';
import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/resources/api.dart';
import 'package:chatwave/utils/colors.dart';
import 'package:chatwave/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final bool next;

  const SearchScreen(
      {Key? key,
      required this.userModel,
      required this.firebaseUser,
      required this.next})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController SearchController = TextEditingController();

  bool isButtonActive = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(
            "Search",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )),
            //margin: EdgeInsets.all(20),
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        isButtonActive = true;
                      });
                    } else {
                      setState(() {
                        isButtonActive = false;
                      });
                    }
                  },
                  controller: SearchController,
                  style: TextStyle(color: backgroundColor),
                  decoration: const InputDecoration(
                      labelText: "Email Address",
                      labelStyle: TextStyle(color: grey),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
                SizedBox(
                  height: 5,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("email", isEqualTo: SearchController.text)
                        .where("email", isNotEqualTo: widget.userModel.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          if (dataSnapshot.docs.isNotEmpty) {
                            Map<String, dynamic> userMap = dataSnapshot.docs[0]
                                .data() as Map<String, dynamic>;

                            UserModel searchedUser = UserModel.fromMap(userMap);

                            return Stack(children: [
                              Image.asset(
                                'assets/images/successfu.gif',
                                height: 200,
                                width: double.infinity,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 60),
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: ListTile(
                                  onTap: () async {
                                    ChatRoomModel? chatroomModel =
                                        await getChatroomModel(searchedUser,widget.userModel);

                                    if (chatroomModel != null) {
                                      Navigate(context,searchedUser, chatroomModel,widget.next,widget.userModel,widget.firebaseUser);
                                    }
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        searchedUser.profilePhoto!),
                                    backgroundColor: Colors.grey[500],
                                  ),
                                  title: Text(
                                    searchedUser.username.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    searchedUser.email.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: Colors.white,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                            ]);
                          } else if (isButtonActive) {
                            return Column(
                              children: [
                                Image.asset(
                                  'assets/images/not_found.gif',
                                  height: 200,
                                ),
                                const Text(
                                  "The usern is not found!",
                                  style: TextStyle(
                                      fontSize: 16, color: backgroundColor),
                                )
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Image.asset(
                                  'assets/images/looking_for_results.gif',
                                  height: 200,
                                ),
                                const Text(
                                  "Find Friends",
                                  style: TextStyle(
                                      fontSize: 16, color: backgroundColor),
                                )
                              ],
                            );
                          }
                        } else if (snapshot.hasError) {
                          return const Text(
                            "An error occured!",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          );
                        } else {
                          return const Text(
                            "No results found!",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          );
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
