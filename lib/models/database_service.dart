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

  getChats(String email) async {
    return userCollection
        .doc(email)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  // send message
  sendMessage(String email, Map<String, dynamic> chatMessageData) async {
    userCollection.doc(email).collection("messages").add(chatMessageData);
    userCollection.doc(email).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}