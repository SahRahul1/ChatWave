import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/resources/api.dart';
import 'package:chatwave/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class EditProfile extends StatefulWidget {
  final UserModel userModel;

  const EditProfile(
      {Key? key, required this.userModel})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController user_name_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? username = widget.userModel.username.toString();
    double width = MediaQuery.of(context).size.width;
    final AuthMethods _authMethods = AuthMethods();
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Profile"),
          elevation: 0,
        ),
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15),
                margin: const EdgeInsets.only(top: 10, bottom: 15),
                decoration: const BoxDecoration(
                    color: button,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                height: 218,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Text("Profile Photo",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      trailing: SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(10), // Image border
                              child: SizedBox(
                                width: 50,
                                child: CachedNetworkImage(
                                  imageUrl: widget.userModel.profilePhoto.toString(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: 0.2,
                        decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 7)),
                    ListTile(
                        leading: const Text("Account",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        trailing: Text(widget.userModel.email.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16))),
                    Container(
                        height: 0.2,
                        decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: const EdgeInsets.fromLTRB(10, 7, 10, 5)),
                    ListTile(
                        onTap: () {
                          user_name_controller.text = username;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  title: const Text(
                                    "Enter Your name",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  content: TextField(
                                    controller: user_name_controller,
                                    style:
                                        const TextStyle(color: backgroundColor),
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                        labelText: "Email Address",
                                        labelStyle: TextStyle(color: grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black))),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.purple),
                                        )),
                                    TextButton(
                                        onPressed: (){
                                          UpdateUsarname(context,user_name_controller.text,username, widget.userModel);
                                        },
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.purple),
                                        ))
                                  ],
                                );
                              });
                        },
                        leading: const Text("Display Name",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        trailing: SizedBox(
                          width: width / 1.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(widget.userModel.username.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              const Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              ElevatedButton(
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
                child: const Text("Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                onPressed: () {
                  _authMethods.signOut(context);
                },
              )
            ],
          ),
        )));
  }
}
