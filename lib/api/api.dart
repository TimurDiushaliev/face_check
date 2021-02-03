import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:facecheck/main.dart';
import 'package:facecheck/models/profile_model.dart';
import 'package:facecheck/view/camera.dart';
import 'package:facecheck/view/checkPage.dart';
import 'package:facecheck/view/error.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class Api {
  BuildContext dialogContext;
  static String baseUrl = 'http://188.225.73.135/api/';
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

  Future<http.Response> getRequest(context, id) async {
    try {
      showAlertDialog(context);
      final apiUrl = baseUrl + 'timecontrol/$id/';
      final response = await http.get(apiUrl, headers: headers);
      print('get response ${json.decode(response.body)}');
      Navigator.pop(dialogContext);
      return response;
    } on TimeoutException catch (e) {
      Navigator.pop(dialogContext);
      Toast.show(
          'Вышло время ожидания, проверьте интернет подключение', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      Navigator.pop(dialogContext);
      Toast.show(
          'Связь с сервером прервана, проверьте интернет подключение', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      print('Socket Error: $e');
    } catch (e) {
      Navigator.pop(dialogContext);
      print('General Error: $e');
    }
  }

  Future<http.Response> postRequest(context, body, id) async {
    try {
      showAlertDialog(context);
      final apiUrl = baseUrl + 'timecontrol/$id/';
      final response =
          await http.post(apiUrl, headers: headers, body: json.encode(body));
      Navigator.pop(dialogContext);
      return response;
    } on TimeoutException catch (e) {
      Navigator.pop(dialogContext);
      Toast.show(
          'Вышло время ожидания, проверьте интернет подключение', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      Navigator.pop(dialogContext);
      Toast.show(
          'Связь с сервером прервана, проверьте интернет подключение', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      print('Socket Error: $e');
    } catch (e) {
      Navigator.pop(dialogContext);
      Toast.show(
          'Произошла ошибка, попробуйте снова через некоторое время', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
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
          Toast.show('Такого пользователя не существует', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          Navigator.pop(dialogContext);
        }
      } on SocketException catch (e) {
        print('Socket exception $e');
        Toast.show('Связь с сервером потеряна, повторите снова', context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.pop(dialogContext);
      } on TimeoutException catch (e) {
        print('Timeout exception $e');
        Toast.show('Вышло время ожидания, повторите снова', context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.pop(dialogContext);
      } catch (e) {
        print('General error $e');
        Navigator.pop(dialogContext);
        Toast.show(
            'Произошла ошибка, попробуйте снова через некоторое время', context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    } else {
      Toast.show('Поля не должны быть пустыми', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.pop(dialogContext);
    }
  }

  static upload(File imageFile, context) async {
    try {
      // open a bytestream
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();
      // string to uri
      var uri = Uri.parse(baseUrl + 'image/compare/');
      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));

      // add file to multipart
      request.files.add(multipartFile);
      request.headers.addAll(headers);

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
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ErrorPage()));
      }
    } on SocketException catch (e) {
      print('Socket exception $e');
      Toast.show('Связь с сервером потеряна, повторите снова', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } on TimeoutException catch (e) {
      print('Timeout exception $e');
      Toast.show('Вышло время ожидания, повторите снова', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } catch (e) {
      print('General error $e');
      Toast.show(
          'Произошла ошибка, попробуйте снова через некоторое время', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
  }
}
