import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:g2hv1/constants.dart';

class AppErrorAlertDialog {
  void show(context) {
    EdgeAlert.show(context,
        backgroundColor: kLoadingBodyBackground,
        icon: Icons.error,
        title: 'Something is broken!',
        description:
            'Looks like something is wrong. Check your network connection. Check and update the app',
        gravity: EdgeAlert.TOP,
        duration: EdgeAlert.LENGTH_VERY_LONG);
  }
}

class InvalidInputAlertDialog {
  void show(context) {
    EdgeAlert.show(context,
        backgroundColor: kLoadingBodyBackground,
        icon: Icons.error,
        title: 'Invalid Input!',
        description:
            'Looks like what you\'ve entered is wrong. Check and try again',
        gravity: EdgeAlert.TOP,
        duration: EdgeAlert.LENGTH_VERY_LONG);
  }
}
