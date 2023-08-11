import 'package:chatwave/models/chat_room_models.dart';
import 'package:chatwave/models/message_model.dart';
import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/widgets/my_message_card.dart';
import 'package:chatwave/widgets/sender_message_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ChatList extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final ChatRoomModel chatroom;

  const ChatList({Key? key, required this.userModel, required this.firebaseUser, required this.chatroom}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("chatrooms").doc(chatroom.chatroomid).collection("messages").orderBy("createdon", descending: true).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active) {
          if(snapshot.hasData) {
            QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;;
            return ListView.builder(
              reverse: true,
              itemCount: dataSnapshot.docs.length,
              itemBuilder: (context, index) {
                MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                if (currentMessage.sender == userModel.uid) {
                  return MyMessageCard(
                    // date: currentMessage.createdon as DateTime,
                    // currentMessage:currentMessage.seen as bool,
                    currentMessage:currentMessage,
                    chatroom: chatroom,
                  );
                }
                return SenderMessageCard(
                  currentMessage:currentMessage,
                  chatroom: chatroom,
                );
              },
            );
          }
          else if(snapshot.hasError) {
            return const Center(
              child: Text("An error occured! Please check your internet connection."),
            );
          }
          else {
            return const Center(
              child: Text("Say hi to your new friend"),
            );
          }
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
