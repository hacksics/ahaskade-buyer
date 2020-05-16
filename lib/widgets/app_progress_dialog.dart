import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:g2hv1/constants.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:line_icons/line_icons.dart';

class AppProgressDialog {
  final String text;
  final context;
  ProgressDialog pr;
  AppProgressDialog({this.text, @required this.context}) {
    pr = ProgressDialog(context);
    pr.style(
      message: '   $text',
      progressWidget: CircularProgressIndicator(),
      backgroundColor: kLoadingBodyBackground,
      messageTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
    );
  }

  Future<void> show() async {
    await pr.show();
  }

  Future<void> hide() async {
    await pr.hide();
  }
}

class AppProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlowingProgressIndicator(
      child: Icon(
        LineIcons.clock_o,
        size: 40.0,
      ),
      duration: Duration(seconds: 3),
    );
  }
}

class AppProgressBroken extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GlowingProgressIndicator(
          child: Icon(
            LineIcons.chain_broken,
            size: 40.0,
          ),
          duration: Duration(seconds: 3),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            'Looks like something went wrong!. Please retry or restart the app. Problem persists contact support team',
            style: TextStyle(color: Colors.white30, fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
    ;
  }
}
