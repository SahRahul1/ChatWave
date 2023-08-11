import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/models/chat_room_models.dart';
import 'package:chatwave/models/user_model.dart';
import 'package:chatwave/resources/FirebaseHelper.dart';
import 'package:chatwave/screens/chat_screen.dart';
import 'package:chatwave/utils/colors.dart';
import 'package:chatwave/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ContactsList extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final bool isAll;

  const ContactsList({Key? key, required this.userModel, required this.firebaseUser, required this.isAll}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("chatrooms").where("users",arrayContains: userModel.uid).orderBy("lastMessage_time", descending: true).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active) {
          QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;
          if(snapshot.hasData&&chatRoomSnapshot.docs.isNotEmpty&&ischat(chatRoomSnapshot)) {
            return ListView.builder(
              itemCount: chatRoomSnapshot.docs.length,
              itemBuilder: (context, index) {
                ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);
                Map<String, dynamic> participants = chatRoomModel.participants!;

                List<String> participantKeys = participants.keys.toList();
                participantKeys.remove(userModel.uid);
                return FutureBuilder(
                  future: FirebaseHelper.getUserModelById(participantKeys[0]),
                  builder: (context, userData) {
                    if (chatRoomModel.lastMessage !=""||isAll) {
                      if (userData.connectionState == ConnectionState.done) {
                        if (userData.data != null) {
                          UserModel targetUser = userData.data as UserModel;
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ChatScreen(
                                    chatroom: chatRoomModel,
                                    firebaseUser: firebaseUser,
                                    userModel: userModel,
                                    targetUser: targetUser,
                                  );
                                }),
                              );
                            },
                            leading:  InkWell(
                              onTap: (){
                                ShowDialog2(context,targetUser);
                              },
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(50), // Image border
                                  child: SizedBox(
                                    width: 45,
                                    child: CachedNetworkImage(
                                      imageUrl: targetUser.profilePhoto.toString(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),),
                                  ),
                                ),
                            ),
                            title: Titles(targetUser.username.toString(),chatRoomModel.lastMessage.toString(),isAll),
                            subtitle: Subtitle(chatRoomModel.lastMessage.toString(),isAll),
                            trailing: Trailing(chatRoomModel.lastMessage_time!,isAll),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                          );
                        }
                        else {
                          return Container(
                          );
                        }
                      }
                      else {
                        return Container(
                        );
                      }
                    }
                    else{
                      return Container(
                      );
                    }
                  }
                );
              },
            );
          }
          else if(snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          else {
            return const Center(
              child: Text("Welcome to ChatWave",style: TextStyle(
                  color: grey,
                  fontSize: 18
              )
              ),
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
