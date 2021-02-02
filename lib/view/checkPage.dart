
import 'dart:convert';
import 'dart:io';

import 'package:facecheck/models/profile_model.dart';
import 'package:facecheck/view/incoming_outcoming.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../api/api.dart';
import 'done.dart';

class CheckPage extends StatelessWidget {
  final ProfileModel profile;
  const CheckPage({Key key, @required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = Api();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(profile.image.file))),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          try {
            api.getRequest(context, profile.id).then((response) {
              if (response.statusCode == 200) {
                var body = json.decode(response.body);
                print('response body $body');
                if (body['value'] != false) {
                  api.postRequest(context, body, profile.id).then((response)  {
                    if(response.statusCode == 200) {
                      print('${body['value']} completed');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SuccesPage(succesResult: body['value'],)));
                    }
                  });
                }
                else {
                  print('you already complted');
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DonePage()));
                }
              }
            });
          } on SocketException catch(e){
            print('Socket exception $e');
            Toast.show('Связь с сервером прервана, проверьте интренет подключение', context, gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          }
          catch (e) {
            print('Exception $e');
          }
        },
      ),
    );
  }
}
