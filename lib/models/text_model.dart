/* class TextModel {
  final int id;
  //final int userId;
  final String text, wavUrl, createdAt, updatedAt;

  TextModel(
    this.id,
    //this.userId,
    this.wavUrl,
    this.createdAt,
    this.updatedAt,
    this.text,
  );

  TextModel.fromJson(Map<String, dynamic> json)
      : 
        id = json["id"],
        //userId = json["user_id"],
        //wavUrl = json["wav_url"],
        wavUrl = "wnsgur735@naver.com/550k8400-e29b-41d4-a716-446655440006.wav",
        createdAt = json["created_at"],
        updatedAt = json["updated_at"],
        text = json["text"];
}
 */

class TextModel {
  bool success;
  int code;
  String message;
  Data data;

  TextModel({required this.success, required this.code, required this.message, required this.data});

  factory TextModel.fromJson(Map<String, dynamic> json) {
    return TextModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  String type;
  String uuid;
  String wavUrl;
  String text;

  Data({required this.type, required this.uuid, required this.wavUrl, required this.text});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      type: json['type'],
      uuid: json['uuid'],
      wavUrl: ("wnsgur735@naver.com/${json['uuid']}.wav"),
      text: json['text'],
    );
  }
}