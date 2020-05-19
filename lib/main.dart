import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:g2hv1/constants.dart';
import 'package:g2hv1/screens/loading_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(
      Phoenix(
        child: EasyLocalization(
            useOnlyLangCode: true,
            supportedLocales: [Locale('en', ''), Locale('si', '')],
            path: 'lang',
            fallbackLocale: Locale('en', ''),
            child: MyApp()),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SharedPreferences.getInstance();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          color: kColorBackgroundWithOpacity,
        ),
        buttonTheme: ButtonThemeData(
            //buttonColor: Color(0XFF3D4FFA),
            buttonColor: Colors.lightBlueAccent,
            textTheme: ButtonTextTheme.primary),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            //backgroundColor: Color(0XFF3D4FFA),
            backgroundColor: Colors.lightBlueAccent,
            //foregroundColor: Colors.white,
            foregroundColor: Colors.black),
      ),
      home: LoadingScreen(),
    );
  }
}
