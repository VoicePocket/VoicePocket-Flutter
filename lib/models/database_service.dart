import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? email;
  DatabaseService({this.email});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  // saving the userdata
  Future savingUserData(String userName, String email) async {
    return await userCollection.doc(email).set({
      "userName": userName,
      "email": email,
      "profilePic": "",
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  ///내 채팅방 메시지 불러오기
  getChats(String email) async {
    return userCollection
        .doc(email)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  ///친구에게 보낸 채팅 메시지 불러오기, (friendsemail)에 친구의 이메일 넣기
  getFriendsChats(String email, String friendsemail) async {
    return userCollection
        .doc(email)
        .collection(friendsemail)
        .orderBy("time")
        .snapshots();
  }

  ///메시지 전송
  sendMessage(String email, Map<String, dynamic> chatMessageData) async {
    userCollection.doc(email).collection("messages").add(chatMessageData);
    userCollection.doc(email).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  ///친구에게 메시지 전송
  sendMessageForFriend(String email,String friendsemail ,Map<String, dynamic> chatMessageData) async {
    userCollection.doc(email).collection(friendsemail).add(chatMessageData);
    userCollection.doc(email).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}