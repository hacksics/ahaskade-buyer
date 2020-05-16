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
