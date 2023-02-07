class TextModel {
  final int id;
  //final int userId;
  final String text;
  final String wavUrl;
  final String createdAt;
  final String updatedAt;

  TextModel({
    required this.id,
    //required this.userId,
    required this.text,
    required this.wavUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  TextModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        //userId = json['user_id'],
        text = json['text'],
        wavUrl = json['wav_url'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];
}
