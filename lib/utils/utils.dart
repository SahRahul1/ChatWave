import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/models/chat_room_models.dart';
import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/screens/about_page.dart';
import 'package:chatwave/screens/chat_screen.dart';
import 'package:chatwave/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const AppVersion = '2.0.0';
const AppName = 'ChatWave';
const link = "app link...........";
const description =
    "ChatWave is a free, secure, and easy-to-use messaging app that allows you to stay connected with friends and family. With ChatWave, you can send messages in real-time, as well as make voice and video calls with just a tap. The app is designed with a user-friendly interface and offers a good chatting experience.";
const bg = 'assets/images/backgroundImage.jpg';

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}


//email type
String email_type(String email) {
  int i;
  String str = "";
  for (i = 0; i < email.length; i++) {
    if (email[i] == '@') {
      while (i < email.length) {
        str = str + email[i++];
      }
      break;
    }
  }
  return str;
}

//Navigate into ChatScreen
void Navigate(
    BuildContext context,
    UserModel searchedUser,
    ChatRoomModel chatroomModel, bool next, UserModel userModel, User firebaseUser,
    ) {
  if (next) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ChatScreen(
        targetUser: searchedUser,
        userModel: userModel,
        firebaseUser: firebaseUser,
        chatroom: chatroomModel,
      );
    }));
  } else {
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ChatScreen(
        targetUser: searchedUser,
        userModel: userModel,
        firebaseUser: firebaseUser,
        chatroom: chatroomModel,
      );
    }));
  }
}

//QuerySnapshot have any chat or not.
bool ischat(QuerySnapshot<Object?> chatRoomSnapshot) {
  int itemCount= chatRoomSnapshot.docs.length,i=0,c=0;
  while(i<itemCount){
    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[i++].data() as Map<String, dynamic>);
    if (chatRoomModel.lastMessage =="") {
      c++;
    }
  }
  if(itemCount==c) {
    return false;
  }
  else {
    return true;
  }
}


Titles(String username,String lastMessage,bool isAll) {
  if(isAll)
    {
      if(lastMessage=='')
        {
          return Row(
            children: [
              Text(username,
                  style: const TextStyle(
                      color: grey,
                      fontSize: 18
                  )
              ),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                radius: 3,
                backgroundColor: Colors.green,
              )
            ],
          );
        }
        else{
        return  Text(username,
            style: const TextStyle(
                color: grey,
                fontSize: 18
            )
        );
      }
    }
  else{
    return  Text(username,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 18
        )
    );
  }

}

Subtitle(String lastMessage,bool isAll) {
  if(isAll)
    {
      return null;
    }
  else{
    return Text(lastMessage,
        style: const TextStyle(
            color: grey,
            fontSize: 14
        ));
  }
}

Trailing(DateTime lastmessageTime,bool isAll) {
  if(isAll)
  {
    return const Icon(
      Icons.keyboard_arrow_right_rounded,
      color: grey,
    );
  }
  else{
    var d1 = DateFormat('dd/MM/yyyy').format(lastmessageTime);
    var d2 = DateFormat('dd/MM/yyyy').format(DateTime.now());
    if (d1 == d2) {
      return Text(
        DateFormat('kk-mm').format(lastmessageTime),
        style: const TextStyle(
          fontSize: 14,
          color: grey,
        ),
      );
    } else {
      return Text(
        d1,
        style: const TextStyle(
          fontSize: 14,
          color: grey,
        ),
      );
    }
  }
}

//Showing Dialog accordingly input.
ShowDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(20))),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  )
              ),
              Text("Version "+AppVersion,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  )
              ),
            ],
          ),
          content: const Text(description,
              style: TextStyle(
                  color: Colors.black, fontSize: 16)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Got It",
                  style: TextStyle(
                      fontSize: 16, color: Colors.purple),
                )),
          ],
        );
      });
}


ShowDialog2(BuildContext context, UserModel? targetUser) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(20))),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(50), // Image border
                    child: SizedBox(
                      width: 45,
                      child: CachedNetworkImage(
                        imageUrl: targetUser!.profilePhoto.toString(),
                        errorWidget: (context, url, error) => Icon(Icons.error),),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(targetUser.username.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          )),
                      Text(targetUser.email.toString().substring(0, 4) +
                          "****" + email_type(targetUser.email!.toString()),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AboutPage(
                        targetUser: targetUser,);
                    },
                  ));
                },
                child: const Text(
                  "More Details",
                  style: TextStyle(
                      fontSize: 16, color: Colors.purple),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Got It",
                  style: TextStyle(
                      fontSize: 16, color: Colors.purple),
                )),
          ],
        );
      });
}


