import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:g2hv1/constants.dart';
import 'package:g2hv1/widgets/common.dart';

// TODO: add feature to send a HTTP POST to crash service. however for that also we need to properly handle errors to ensure this screen is not shown again and again

void setErrorBuilder(BuildContext context) {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Scaffold(
        body: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(kTextCrashScreenTitle),
        //Text('Error: $errorDetails'),
        SizedBox(
          height: 20.0,
        ),
        AppTextButton(
          onPressed: () {
            Phoenix.rebirth(context);
          },
          buttonText: 'Restart App',
        ),
      ],
    )));
  };
}
