
import 'dart:convert';

import 'package:facecheck/models/profile_model.dart';
import 'package:facecheck/view/incoming_outcoming.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import 'done.dart';

class CheckPage extends StatelessWidget {
  final ProfileModel profile;
  const CheckPage({Key key, @required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('1 $profile');
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
            Api.getRequest(context, profile.id).then((response) {
              if (response.statusCode == 200) {
                var body = json.decode(response.body);
                print('response body $body');
                if (body['value'] != false) {
                  print('fsd');
                  Api.postRequest(context, body, profile.id).then((response)  {
                    print('fsdaww');
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
          } catch (e) {
            print('Exception $e');
          }
        },
      ),
    );
  }
}
