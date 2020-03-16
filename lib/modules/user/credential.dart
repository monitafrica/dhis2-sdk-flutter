

import 'package:dhis2sdk/core/model.dart';

@Model
class Credential implements ModelInterface{
  String url;
  String username;
  String password;

  Credential({this.url, this.username, this.password});

  Credential.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}