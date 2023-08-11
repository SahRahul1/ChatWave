import 'package:chatwave/models/chat_room_models.dart';
import 'package:chatwave/models/message_model.dart';
import 'package:chatwave/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class MyMessageCard extends StatelessWidget {
  final MessageModel currentMessage;
  final ChatRoomModel chatroom;

  const MyMessageCard({Key? key, required this.currentMessage, required this.chatroom}) : super(key: key);

  IsSeen() {
    if(currentMessage.seen as bool)
    {
      return const Icon(
        Icons.done_all,
        size: 20,
        color: Colors.blue,
      );
    }
    else{
      return const Icon(
        Icons.done_all,
        size: 20,
        color: Colors.white60,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8,bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 80,
                maxWidth: MediaQuery.of(context).size.width - 45,
              ),
              child: Card(
                elevation: 1,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)
                )),
                color: messageColor,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 30,
                        top: 5,
                        bottom: 22,
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
                      child: Row(
                        children: [
                          Text(
                            DateFormat('kk-mm').format(currentMessage.createdon as DateTime),
                            style:const TextStyle(
                              fontSize: 13,
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IsSeen(),
                        ],
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
