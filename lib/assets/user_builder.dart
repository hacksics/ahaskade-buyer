import 'package:get/get.dart';
import 'package:g2hv1/assets/user.dart';
import 'dart:convert';

class UserController extends GetController {
  static UserController get to => Get.find(); // add this line
  User user;
  void initUser(var json) {
    user = User.fromJson(json);
    update(this);
  }
}
