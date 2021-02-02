import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccesPage extends StatelessWidget {
  final String succesResult;
  SuccesPage({Key key, @required this.succesResult}) : super(key: key);
  String result;
  Map<String, String> results = {"incoming": "Приход", "outcoming": "Уход"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('images/succes.svg'),
            Text('Вы выполнили: ${results[succesResult]}'),
          ],
        ),
      ),
    );
  }
}
