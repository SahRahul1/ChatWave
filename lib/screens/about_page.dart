import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/utils/colors.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  final UserModel targetUser;
  const AboutPage(
      {Key? key, required this.targetUser}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("About"),
      ),
      body: Container(
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
                            child:SizedBox(
                              width: 50,
                              child: CachedNetworkImage(
                                imageUrl: widget.targetUser.profilePhoto.toString(),
                                errorWidget: (context, url, error) => Icon(Icons.error),),
                            ),
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
                      leading: const Text("User Name",
                          style:
                          TextStyle(color: Colors.white, fontSize: 16)),
                      trailing: Text(widget.targetUser.username.toString(),
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
                      leading: const Text("Account",
                          style:
                          TextStyle(color: Colors.white, fontSize: 16)),
                      trailing: Text(widget.targetUser.email.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16))),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
