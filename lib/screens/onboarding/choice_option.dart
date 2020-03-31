import 'package:flutter/material.dart';
import 'package:teloswallet/constants/app_colors.dart';
import 'package:teloswallet/widgets/main_button.dart';

class ChoiceOption extends StatelessWidget {
  final Function onCreate;
  final Function onImport;

  ChoiceOption({ this.onCreate, this.onImport });
  
  Widget buildGroup(String text, String title, Function onPressed) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 7),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Icon(Icons.arrow_downward, color: AppColors.blue, size: 25),
        MainButton(
          margin: EdgeInsets.only(left: 33, right: 33, top: 10),
          title: title,
          onPressed: onPressed,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        buildGroup(
          'If you have an account\nclick here',
          'Import private key',
          onImport,
        ),
        buildGroup(
          'If you want to create account\nclick here',
          'Create account',
          onCreate,
        ),
      ],
    );
  }
}
