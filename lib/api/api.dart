import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:facecheck/main.dart';
import 'package:facecheck/models/profile_model.dart';
import 'package:facecheck/view/camera.dart';
import 'package:facecheck/view/checkPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class Api {
  BuildContext dialogContext;
  static String baseUrl = 'http://192.168.88.233:8000/api/';
  static Map<String, String> headers = {
    'Content-type': 'application/json; charset=Utf-8'
  };
  static var box = Hive.box('myBox');
  showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      content: Row(children: [
        CircularProgressIndicator(),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text('Подождите...'),
        )
      ]),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return alertDialog;
        });
  }

  static Future<http.Response> getRequest(context, id) async {
    try {
      final apiUrl = baseUrl + 'timecontrol/$id/';
      final response = await http.get(apiUrl, headers: headers);
      print('get response ${json.decode(response.body)}');
      return response;
    } on TimeoutException catch (e) {
      Toast.show(
          'Вышло время ожидания, проверьте интернет подключение', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      Toast.show(
          'Связь с сервером прервана, проверьте интернет подключение', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      print('Socket Error: $e');
    } on Error catch (e) {
      print('General Error: $e');
    }
  }

  static Future<http.Response> postRequest(context, body, id) async {
    try {
      final apiUrl = baseUrl + 'timecontrol/$id/';
      final response =
          await http.post(apiUrl, headers: headers, body: json.encode(body));
      return response;
    } on TimeoutException catch (e) {
      Toast.show(
          'Вышло время ожидания, проверьте интернет подключение', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      Toast.show(
          'Связь с сервером прервана, проверьте интернет подключение', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      print('Socket Error: $e');
    } on Error catch (e) {
      print('General Error: $e');
    }
  }

  Future login(String username, String password, context) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        showAlertDialog(context);
        final String apiUrl = baseUrl + 'auth/token/login/';
        final body = {'username': username, 'password': password};
        final response =
            await http.post(apiUrl, headers: headers, body: json.encode(body));
        print('response ${json.decode(response.body)}');
        if (response.statusCode == 200) {
          final Map responseBody = json.decode(response.body);
          final token = responseBody['auth_token'];
          headers['Authorization'] = 'Token $token';
          print('1: ${headers['Authorization']}');
          box.put('username', username);
          box.put('password', password);
          box.put('token', token);
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CameraPage()))
              .then((value) => Navigator.pop(dialogContext))
              .then((value) => passwordController.clear());
        } else {
          print('login result is false');
          Toast.show('Такого пользователя не существует', context, gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          Navigator.pop(dialogContext);
        }
      } on SocketException catch (e) {
        print('Socket exception $e');
        Toast.show('Связь с сервером потеряна, повторите снова', context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.pop(dialogContext);
      } on TimeoutException catch (e) {
        print('Timeout exception $e');
        Toast.show('Связь с сервером потеряна, повторите снова', context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.pop(dialogContext);
      } on Error catch (e) {
        print('General error $e');
        Toast.show('Связь с сервером потеряна, повторите снова', context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.pop(dialogContext);
      }
    } else {
      Toast.show('Поля не должны быть пустыми', context, gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.pop(dialogContext);
    }
  }

  static upload(File imageFile, context) async {
    // open a bytestream
    print('1');
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    print('2');
    var length = await imageFile.length();
    print('3');
    // string to uri
    var uri = Uri.parse(baseUrl + 'image/compare/');
    print('4');
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    print('5');
    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    print('6');
    // add file to multipart
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    print('7');
    // send
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print('respnse ${json.decode(response.body)}');
    if (response.statusCode == 200) {
      ProfileModel profileModel =
          ProfileModel.fromJson(json.decode(response.body));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CheckPage(profile: profileModel)));
    }
  }
}
