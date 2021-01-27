import 'package:facecheck/api/api.dart';
import 'package:facecheck/main.dart';
import 'package:flutter/material.dart';

import 'face_check.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List keys = ['username', 'password', 'token'];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  Api.box.deleteAll(keys);
                  passwordController.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                }),
          ],
        ),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constaints) {
              return IconButton(
                  icon: Icon(Icons.camera),
                  // color: Colors.blue,
                  iconSize: constaints.maxHeight * 0.15,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FaceCheckPage()));
                  });
            },
          ),
        ),
      ),
    );
  }
}
