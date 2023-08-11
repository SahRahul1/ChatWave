import 'dart:io';

import 'package:chatwave/models/chat_room_models.dart';
import 'package:chatwave/models/message_model.dart';
import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

UpdateUsarname(BuildContext context,String user_name, String username, UserModel userModel) async {
  try{
    await InternetAddress.lookup('google.com');
    if (user_name != "") {
      if (user_name ==
          username) {
        Navigator.pop(context);
      } else {
        userModel.username =
            user_name;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userModel.uid)
            .update(
            userModel.toMap());
        Navigator.pop(context);
      }
    }
    else{
      showSnackBar(context, "User name is Empty");
    }
  }on SocketException catch(e){
    Navigator.pop(context);
    showSnackBar(context, "Internet Error!!");
  }
}
// Send Message
void sendMessage(TextEditingController messageController, ChatRoomModel chatroom, UserModel userModel) async {
  String msg = messageController.text.trim();
  messageController.clear();
  if (msg != "") {
    var uuid = const Uuid();
    MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false);

    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroom.chatroomid)
        .collection("messages")
        .doc(newMessage.messageid)
        .set(newMessage.toMap());

    chatroom.lastMessage = msg;
    chatroom.lastMessage_time = DateTime.now();
    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroom.chatroomid)
        .set(chatroom.toMap());
    //print("Message Sent!");
  }
}

//creating chatroom
Future<ChatRoomModel?> getChatroomModel(UserModel targetUser, UserModel userModel) async {
  ChatRoomModel? chatRoom;
  var uuid = Uuid();

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("chatrooms")
      .where("participants.${userModel.uid}", isEqualTo: true)
      .where("participants.${targetUser.uid}", isEqualTo: true)
      .get();

  if (snapshot.docs.isNotEmpty) {
    // Fetch the existing one
    var docData = snapshot.docs[0].data();
    ChatRoomModel existingChatroom =
    ChatRoomModel.fromMap(docData as Map<String, dynamic>);

    chatRoom = existingChatroom;
  } else {
    // Create a new one
    ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        lastMessage_time: DateTime.now(),
        participants: {
          userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
        users: [
          userModel.uid.toString(),
          targetUser.uid.toString()
        ]);

    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(newChatroom.chatroomid)
        .set(newChatroom.toMap());

    chatRoom = newChatroom;

    //print("New Chatroom Created!");
  }

  return chatRoom;
}