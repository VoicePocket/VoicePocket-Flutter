import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/models/friendship_model.dart';
import 'package:voicepocket/models/friendship_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:voicepocket/models/friendship_request_get_model.dart';
import 'package:voicepocket/services/global_var.dart';

Future<FriendShipRequestModel> requestFriendShip(String requestTo) async {
  final pref = await SharedPreferences.getInstance();
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/friend'
      : '$androidUrl/friend';
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
    // } else if (response.statusCode <= -1007 && response.statusCode >= -1005) {
    //   print(response.statusCode);
    //   await tokenRefreshPost();
    //   return FriendShipRequestModel.fromJson(
    //     json.decode(
    //       utf8.decode(response.bodyBytes),
    //     ),
    //   );
  } else {
    return FriendShipRequestModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
  }
}

Future<List<DataG>> get getFriendShipRequest async {
  List<DataG> name = [];
  final pref = await SharedPreferences.getInstance();
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/friend/requests'
      : '$androidUrl/friend/requests';
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
    return name;
  }
}

Future<FriendShipModel> acceptFriendShip(String email) async {
  final pref = await SharedPreferences.getInstance();
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/friend/request/ACCEPT'
      : '$androidUrl/friend/request/ACCEPT';
  final http.Response response = await http.put(
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
    return friend;
  } else {
    FriendShipModel friend = FriendShipModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    return friend;
  }
}

Future<FriendShipModel> rejectFriendShip(String email) async {
  final pref = await SharedPreferences.getInstance();
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/friend/request/REJECT'
      : '$androidUrl/friend/request/REJECT';
  final http.Response response = await http.put(
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
    return friend;
  } else {
    FriendShipModel friend = FriendShipModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    return friend;
  }
}

Future<List<DataG>> get getFriendShip async {
  List<DataG> name = [];
  final pref = await SharedPreferences.getInstance();
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/friend'
      : '$androidUrl/friend';
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
        if (data.status == "ACCEPT") {
          name.add(data);
        }
      }
    }
    return name;
    // } else if (response.statusCode == -1006) {
    //   // Refresh Token Expired
    //   print(response.statusCode);
    //   return name;
    // } else if (response.statusCode == -1007) {
    //   // Access Token Expired
    //   print(response.statusCode);
    //   await tokenRefreshPost();
    //   return await getFriendShip();
  } else {
    return name;
  }
}

Future<List<DataG>> get getSendFriendShip async {
  List<DataG> name = [];
  final pref = await SharedPreferences.getInstance();
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/friend'
      : '$androidUrl/friend';
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
        if (data.status == "ONGOING") {
          name.add(data);
        }
      }
    }
    return name;
    // } else if (response.statusCode == -1006) {
    //   // Refresh Token Expired
    //   print(response.statusCode);
    //   return name;
    // } else if (response.statusCode == -1007) {
    //   // Access Token Expired
    //   print(response.statusCode);
    //   await tokenRefreshPost();
    //   return await getSendFriendShip();
  } else {
    return name;
  }
}
