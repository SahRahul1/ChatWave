import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/models/chat_room_models.dart';
import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/resources/api.dart';
import 'package:chatwave/screens/about_page.dart';
import 'package:chatwave/utils/colors.dart';
import 'package:chatwave/utils/utils.dart';
import 'package:chatwave/widgets/chat_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatScreen(
      {Key? key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: appBarColor,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        leading: const BackButton(
          color: Colors.white,
        ),
        title: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return AboutPage(
                    targetUser: widget.targetUser,);
              },
            ));
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(50), // Image border
                child: SizedBox(
                  width: 40,
                  child: CachedNetworkImage(
                    imageUrl: widget.targetUser.profilePhoto.toString(),
                    errorWidget: (context, url, error) => Icon(Icons.error),),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(widget.targetUser.username.toString()),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            //color: Colors.green,
            image: DecorationImage(
                image: AssetImage(
                  bg,
                ),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: ChatList(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                    chatroom: widget.chatroom,
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(left: 7, bottom: 5, top: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: mobileChatBoxColor,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(
                              Icons.emoji_emotions,
                              color: grey,
                            ),
                          ),
                          hintText: "Message",
                          hintStyle: const TextStyle(
                            color: grey,
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      margin: const EdgeInsets.only(left: 5, right: 8),
                      padding: const EdgeInsets.only(left: 4),
                      decoration: const BoxDecoration(
                          color: tabColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          size: 25,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          sendMessage(messageController,widget.chatroom,widget.userModel);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
