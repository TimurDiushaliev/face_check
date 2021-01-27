import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'api/api.dart';
import 'style/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  await Hive.init(document.path);
  await Hive.openBox('myBox');
  runApp(MaterialApp(home: LoginPage()));
}

TextEditingController passwordController = TextEditingController();

class LoginPage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();

  final api = Api();

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: _height,
        width: _width,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              margin: EdgeInsets.only(top: constraints.maxHeight * 0.25),
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(bottom: constraints.maxHeight * 0.05),
                    child: TextField(
                      controller: nameController,
                      decoration: Style.adminInputDecoration,
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(bottom: constraints.maxHeight * 0.05),
                    child: TextField(
                      controller: passwordController,
                      decoration: Style.adminPasswrodStyle,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: _height * 0.06),
                    child: RaisedButton(
                      color: Colors.blue,
                      padding: EdgeInsets.only(
                          top: constraints.maxHeight * 0.03,
                          bottom: constraints.maxHeight * 0.03,
                          left: constraints.maxWidth * 0.38,
                          right: constraints.maxWidth * 0.38),
                      shape: Style.loginButtonStyle,
                      onPressed: () {
                        String username = nameController.text;
                        String password = passwordController.text;
                        api.login(username, password, context);
                      },
                      child: Text('Войти'),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
