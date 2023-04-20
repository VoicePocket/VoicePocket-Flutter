class SignUpPost {
  bool success;
  int code;
  String message;

  SignUpPost({
    required this.success,
    required this.code,
    required this.message,
  });

  factory SignUpPost.fromJson(Map<String, dynamic> json) {
    return SignUpPost(
      success: json['success'],
      code: json['code'],
      message: json['message'],
    );
  }
}
