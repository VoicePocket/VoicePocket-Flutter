import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/models/friendship_model.dart';
import 'package:http/http.dart' as http;
import 'package:voicepocket/models/friendship_request_model.dart';

import '../constants/sizes.dart';

Future<FriendShipModel> requestFriendShip(String requestTo) async {
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
    FriendShipModel friend = FriendShipModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    if (friend.success) {
      print(friend.data!.requestTo.name);
    }
    return friend;
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
    return friend;
  }
}

Future<List<String>> get getFriendShipRequest async {
  List<String> name = [];
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
    FriendShipRequestModel friend = FriendShipRequestModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    if (friend.success) {
      for (var data in friend.data) {
        name.add(data.requestFrom.name);
      }
    }
    return name;
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
    return name;
  }
}
