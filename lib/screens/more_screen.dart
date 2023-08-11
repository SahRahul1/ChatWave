import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/screens/edit_profile.dart';
import 'package:chatwave/utils/utils.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'package:share_plus/share_plus.dart';

class MoreScreen extends StatefulWidget {
  final UserModel userModel;

  const MoreScreen(
      {Key? key, required this.userModel})
      : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("More"),
          elevation: 0,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: button,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return EditProfile(
                            userModel: widget.userModel);
                      },
                    ));
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Image border
                    child: SizedBox(
                      width: 45,
                      child: CachedNetworkImage(
                        imageUrl: widget.userModel.profilePhoto.toString(),
                        errorWidget: (context, url, error) => Icon(Icons.error),),
                    ),
                  ),
                  title: Text(
                    widget.userModel.username.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    widget.userModel.email.toString().substring(0, 4) +
                        "*****" +
                        email_type(widget.userModel.email.toString()),
                    style: const TextStyle(
                      color: grey,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    right: 10, left: 10, bottom: 10, top: 30),
                decoration: const BoxDecoration(
                    color: button,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: ListTile(
                  onTap: () {
                    Share.share(link);
                  },
                  leading: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: Colors.white,
                  ),
                  title: const Text("Invite friends",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  trailing: const Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Container(
                //padding: EdgeInsets.only(left: 8,right: 9),
                margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                decoration: const BoxDecoration(
                    color: button,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: ListTile(
                  onTap: () {
                    ShowDialog(context);
                  },
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                  title: const Text("About",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                decoration: const BoxDecoration(
                    color: button,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: ListTile(
                  leading: const Icon(
                    Icons.android_rounded,
                    color: Colors.green,
                  ),
                  title: const Text("App version",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  trailing: const Text("2.0.0",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("from",
                      style: TextStyle(color: grey, fontSize: 15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.all_inclusive_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Spectrum",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}

