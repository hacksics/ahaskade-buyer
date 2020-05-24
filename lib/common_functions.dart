import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'constants.dart';

String formatDoubleToPrice(double price) {
  return '${NumberFormat.currency(locale: kLocale, symbol: kCurrencySymbol).format(price)}';
}

String getFormattedDate(double epochTime) {
  double microSecondsSinceEpoch = epochTime * 1000000;
  var date =
      new DateTime.fromMicrosecondsSinceEpoch(microSecondsSinceEpoch.toInt());
  return new DateFormat("yyyy-MM-dd hh:mm a").format(date);
}

AppBar getWhiteAppBar(String title) {
  return AppBar(
    title: Text(title, style: TextStyle(color: Colors.black)),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  );
}

Future<void> showAlertDialog(
    {@required String error, String errorDetails}) async {
  String contentSummary = errorDetails == null
      ? 'Looks like some failure in the app. You may check the details below to see whats wrong.'
      : errorDetails;

  Get.dialog(
    AlertDialog(
      title: Text('Oops! Something wrong'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(contentSummary),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Details:',
            style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
          ),
          Text(
            error,
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'SourceCodePro',
            ),
            maxLines: 6,
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Get.back();
          },
        )
      ],
    ),
    barrierDismissible: false,
  );
}

Future<void> showSimpleAlertDialog(
    {@required String title, @required String details}) async {
  Get.dialog(
    AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(details),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Get.back();
          },
        )
      ],
    ),
    barrierDismissible: false,
  );
}
