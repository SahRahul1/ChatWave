import 'package:chatwave/models/chat_room_models.dart';
import 'package:chatwave/models/message_model.dart';
import 'package:chatwave/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SenderMessageCard extends StatelessWidget {

  final MessageModel currentMessage;
  final ChatRoomModel chatroom;

  const SenderMessageCard({Key? key, required this.currentMessage, required this.chatroom}) : super(key: key);


  void MessageUpdate() {
    if (!(currentMessage.seen as bool)) {
      currentMessage.seen=true;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroom.chatroomid)
          .collection("messages")
          .doc(currentMessage.messageid)
          .update(currentMessage.toMap());
     }
  }


  @override
  Widget build(BuildContext context) {
    MessageUpdate();
    return Padding(
      padding: const EdgeInsets.only(left: 8,bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth:70,
                maxWidth: MediaQuery.of(context).size.width - 45,
              ),
              child: Card(
                elevation: 1,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)
                )),
                color: mobileChatBoxColor,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 30,
                        top: 5,
                        bottom: 20,
                      ),
                      child: Text(
                        currentMessage.text.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 10,
                      child: Text(
                        DateFormat('kk-mm').format(currentMessage.createdon as DateTime),
                        style: TextStyle(
                          fontSize: 13,
                          color: grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            DateFormat('dd-MM-yyyy').format(currentMessage.createdon as DateTime),
            style: TextStyle(
              fontSize: 13,
              color: grey,
            ),
          ),
        ],
      ),
    );
  }
}