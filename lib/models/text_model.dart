class TextModel {
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
      : id = json["id"],
        //userId = json["user_id"],
        wavUrl = json["wav_url"],
        createdAt = json["created_at"],
        updatedAt = json["updated_at"],
        text = json["text"];
}
