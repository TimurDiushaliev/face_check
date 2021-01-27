import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccesPage extends StatelessWidget {
  final String succesResult;
  const SuccesPage({Key key, @required this.succesResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('images/succes.svg'),
              Text('Вы выполнили $succesResult'),
            ],
          ),
      ),
    );
  }
}
