import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dhis2.dart';

class DHISHttpClient {
  static DHISHttpClient _instance;
  DHISHttpClient() {
    if(_instance != null){
      DHISHttpClient._instance = this;
    }
  }

  void initState() {}

  Future<Dio> clientAuthenticationObject() async {
    var token = await getToken();
    Dio dioRequests = new Dio(new BaseOptions(
      connectTimeout: 100000,
      receiveTimeout: 100000,
      headers: {
        HttpHeaders.userAgentHeader: "dio",
        "api": "1.0.0",
        HttpHeaders.authorizationHeader: token,
        // "Content-Type": 'application/json',
      },
      contentType: 'application/json',
      responseType: ResponseType.json,
    ));
    (dioRequests.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
    return dioRequests;
  }

  Future<Response<dynamic>> get(url,{
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    Dio client = await clientAuthenticationObject();
    return client.get(url,queryParameters:queryParameters,options:options,cancelToken:cancelToken, onReceiveProgress: onReceiveProgress);
  }

  post(url, data) async {
    var client = await clientAuthenticationObject();
    return client.post(url, data: data);
  }

  put(url, data) async {
    var client = await clientAuthenticationObject();
    return client.put(url, data: data);
  }

  delete(url) async {
    var client = await clientAuthenticationObject();
    return client.delete(url);
  }

  getToken() async {
    var token = 'Basic ' + base64Encode(utf8.encode('${DHIS2.credentials.username}:${DHIS2.credentials.password}'));
    return token;
  }

  setToken(token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tulonge_user_token', token);
  }
}
