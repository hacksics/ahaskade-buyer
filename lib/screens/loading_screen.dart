import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:g2hv1/assets/config_loader.dart';
import 'package:g2hv1/enums.dart';
import 'package:g2hv1/assets/user_builder.dart';
import 'package:g2hv1/screens/home_screen.dart';
import 'package:g2hv1/screens/login_screen_mobile_no.dart';
import 'package:g2hv1/screens/user_profile_setup_screen.dart';
import 'package:get/get.dart';
import '../services/data_store.dart' as ds;
import 'dart:developer' as logger;
import 'package:easy_localization/easy_localization.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // Init User State
  UserController userController = Get.put(UserController());
  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  void checkUserStatus() async {
    await loadConfigs();

    var langPref = await ds.readUserPref(key: 'appLanguage');
    if (langPref == "0") {
      logger.log('language not set!');
      await Get.dialog(
        AlertDialog(
          title: Text('Select the preferred language'),
          actions: <Widget>[
            FlatButton(
              child: Text('English'),
              onPressed: () {
                context.locale = Locale('en', '');
                ds.saveUserPref(key: 'appLanguage', value: 'en');
                Get.offAll(LoadingScreen());
              },
            ),
            FlatButton(
              child: Text('සිංහල'),
              onPressed: () {
                context.locale = Locale('si', '');
                ds.saveUserPref(key: 'appLanguage', value: 'si');
                Get.offAll(LoadingScreen());
              },
            )
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      logger.log('setting the language to $langPref');
      context.locale = Locale('$langPref', '');
    }

    var lastLoginDate = await ds.readUserPref(key: 'lastLoginDate');
    int sevenDaysAgoInSeconds =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000) - (60 * 60 * 24 * 7);
    //lastLoginDate = "0";
    if (lastLoginDate == "0" ||
        int.parse(lastLoginDate) < sevenDaysAgoInSeconds) {
      logger.log('user is not found, launching the registration');
      Get.offAll(MobileNumberInputScreen());
    } else {
      UserController.to
          .initUser(jsonDecode(await ds.readUserPref(key: 'user')));
      Get.offAll(HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
