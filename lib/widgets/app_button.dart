import 'package:nice_button/nice_button.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class AppButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  AppButton({this.onPressed, this.buttonText});
  @override
  Widget build(BuildContext context) {
    return NiceButton(
        radius: 10.0,
        text: buttonText,
        background: kButtonBodyColor,
        textColor: kButtonTextColor,
        onPressed: onPressed);
  }
}
