class TextModel {
  final String text;
  final String uuid;

  TextModel({
    required this.uuid,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["uuid"] = uuid;
    data["text"] = text;
    return data;
  }

  TextModel.fromJson(Map<String, dynamic> json)
      : uuid = json["uuid"],
        text = json["text"];
}
