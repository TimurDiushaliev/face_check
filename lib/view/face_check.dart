import 'dart:io';

import 'package:facecheck/api/api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FaceCheckPage extends StatefulWidget {
  FaceCheckPage({Key key}) : super(key: key);

  @override
  _FaceCheckPageState createState() => _FaceCheckPageState();
}

class _FaceCheckPageState extends State<FaceCheckPage> {
  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future getImage() async {
    File image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    print('pickedFile $pickedFile');
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        print('image $image');
        Api.upload(image, context);
      } else {
        print('no image selected');
      }
    });
  }
}
