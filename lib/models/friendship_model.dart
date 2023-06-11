class FriendShipModel {
  bool success;
  int code;
  String message;

  FriendShipModel({
    required this.success,
    required this.code,
    required this.message,
  });

  factory FriendShipModel.fromJson(Map<String, dynamic> json) {
    return FriendShipModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
    );
  }
}
