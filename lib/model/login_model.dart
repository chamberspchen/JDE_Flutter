import 'dart:convert';

class LoginResponseModel {
  String? token;
  String? error;

  LoginResponseModel({this.token, this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["userInfo"] != null
          ? (json["userInfo"]["token"] != null ? json["userInfo"]["token"] : "")
          : "",
      error: json["message"] != null ? json["message"] : "",
    );
  }

  checkToken() {
    if (this.token!.isEmpty)
      return "Token is expired, pls relogin again";
    else
      return token;
  }
}

class LoginRequestModel {
  String? user;
  String? password;
  String? env;
  String? role;

  LoginRequestModel({
    this.user,
    this.password,
  });

  toJson() {
    var body = jsonEncode({
      'username': user!.trim(),
      'password': password!.trim(),
      'environment': env!.trim(),
      'role': role!.trim(),
    });

    return body;
  }
}
