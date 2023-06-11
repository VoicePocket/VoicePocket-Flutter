import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/models/friendship_model.dart';
import 'package:voicepocket/models/friendship_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:voicepocket/models/friendship_request_get_model.dart';

import '../constants/sizes.dart';

Future<FriendShipRequestModel> requestFriendShip(String requestTo) async {
  final pref = await SharedPreferences.getInstance();
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? 'http://localhost:8080/api/friend'
      : 'http://10.0.2.2:8080/api/friend';
  final http.Response response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AUTH-TOKEN': pref.getString("accessToken")!,
    },
    body: jsonEncode(<String, String>{
      'email': requestTo,
    }),
  );
  if (response.statusCode == 200) {
    FriendShipRequestModel friend = FriendShipRequestModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    if (friend.success) {
      print(friend.data!.requestTo.name);
    }
    return friend;
  } else {
    FriendShipRequestModel friend = FriendShipRequestModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    Fluttertoast.showToast(
      msg: friend.message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: const Color(0xFFA594F9),
      fontSize: Sizes.size16,
    );
    return friend;
  }
}

Future<List<DataG>> get getFriendShipRequest async {
  List<DataG> name = [];
  final pref = await SharedPreferences.getInstance();
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? 'http://localhost:8080/api/friend/requests'
      : 'http://10.0.2.2:8080/api/friend/requests';
  final http.Response response = await http.get(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AUTH-TOKEN': pref.getString("accessToken")!,
    },
  );
  if (response.statusCode == 200) {
    FriendShipRequestGetModel friend = FriendShipRequestGetModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    if (friend.success) {
      for (var data in friend.data) {
        name.add(data);
      }
    }
    return name;
  } else {
    FriendShipRequestGetModel friend = FriendShipRequestGetModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    Fluttertoast.showToast(
      msg: friend.message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: const Color(0xFFA594F9),
      fontSize: Sizes.size16,
    );
    return name;
  }
}

Future<bool> acceptFriendShip(String email) async {
  final pref = await SharedPreferences.getInstance();
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? 'http://localhost:8080/api/friend/requests/ACCEPT'
      : 'http://10.0.2.2:8080/api/friend/requests/ACCEPT';
  final http.Response response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AUTH-TOKEN': pref.getString("accessToken")!,
    },
    body: jsonEncode(<String, String>{
      'email': email,
    }),
  );
  if (response.statusCode == 200) {
    FriendShipModel friend = FriendShipModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    if (friend.success) {
      Fluttertoast.showToast(
        msg: "이제 $email과 친구입니다.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor: const Color(0xFFA594F9),
        fontSize: Sizes.size16,
      );
    }
    return true;
  } else {
    FriendShipModel friend = FriendShipModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    Fluttertoast.showToast(
      msg: friend.message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: const Color(0xFFA594F9),
      fontSize: Sizes.size16,
    );
    return false;
  }
}

Future<bool> rejectFriendShip(String email) async {
  final pref = await SharedPreferences.getInstance();
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? 'http://localhost:8080/api/friend/requests/REJECT'
      : 'http://10.0.2.2:8080/api/friend/requests/REJECT';
  final http.Response response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AUTH-TOKEN': pref.getString("accessToken")!,
    },
    body: jsonEncode(<String, String>{
      'email': email,
    }),
  );
  if (response.statusCode == 200) {
    FriendShipModel friend = FriendShipModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    if (friend.success) {
      Fluttertoast.showToast(
        msg: "$email님의 친구 요청을 거절하셨습니.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor: const Color(0xFFA594F9),
        fontSize: Sizes.size16,
      );
    }
    return true;
  } else {
    FriendShipModel friend = FriendShipModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    Fluttertoast.showToast(
      msg: friend.message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: const Color(0xFFA594F9),
      fontSize: Sizes.size16,
    );
    return false;
  }
}
