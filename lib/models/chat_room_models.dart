class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? lastMessage_time;
  List<dynamic>? users;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.lastMessage,
      this.lastMessage_time,
      this.users});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    lastMessage_time = map["lastMessage_time"].toDate();
    users = map["users"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "lastMessage_time": lastMessage_time,
      "users": users,
    };
  }
}
