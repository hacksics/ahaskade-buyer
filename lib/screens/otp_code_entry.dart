import 'package:flutter/material.dart';
import 'package:g2hv1/enums.dart';
import 'package:g2hv1/widgets/common.dart';
import 'package:g2hv1/widgets/main_screen_canvas.dart';
import 'package:g2hv1/constants.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:g2hv1/screens/home_screen.dart';
import 'package:g2hv1/screens/loading_screen.dart';
import 'package:g2hv1/screens/user_profile_setup_screen.dart';
import 'package:g2hv1/services/data_store.dart' as ds;

class OtpInputScreen extends StatefulWidget {
  final int otpCode;
  final String mobileNumber;
  final bool registrationRequired;
  OtpInputScreen(
      {@required this.otpCode,
      @required this.mobileNumber,
      @required this.registrationRequired});
  @override
  _OtpInputScreenState createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  int retryCount = 0;
  int otpCode;
  String mobileNumber;
  bool registrationRequired;
  @override
  void initState() {
    mobileNumber = widget.mobileNumber;
    registrationRequired = widget.registrationRequired;
    otpCode = widget.otpCode;
    super.initState();
  }

  bool validateOtp(String otp) {
    return otp == otpCode.toString() ? true : false;
  }

  void goToHomeScreen() {
    int timeNowInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    ds.saveUserPref(key: 'lastLoginDate', value: timeNowInSeconds.toString());
    registrationRequired == true
        ? Get.offAll(UserProfileSetup(
            mobileNumber: mobileNumber,
            userUpdateMode: UserUpdateMode.New,
          ))
        : Get.offAll(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    String typedOtp;
    print(otpCode);
    return MainScreenCanvas(
      children: <Widget>[
        Text(
          kTextEnter4DigitCode,
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: PinInputTextField(
            keyboardType: TextInputType.number,
            pinLength: 4,
            onChanged: (value) {
              typedOtp = value;
              if (validateOtp(value) == true) {
                goToHomeScreen();
              }
            },
            onSubmit: (value) {
              if (validateOtp(value) == true) {
                goToHomeScreen();
              } else {
                invalidPinDialog();
                retryCount++;
                if (retryCount > 3) {
                  Get.offAll(LoadingScreen());
                }
              }
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        AppTextButton(
          buttonText: kButtonTextOtpSubmit,
          onPressed: () {
            if (validateOtp(typedOtp) == true) {
              goToHomeScreen();
            } else {
              invalidPinDialog();
              retryCount++;
              if (retryCount > 3) {
                Get.offAll(LoadingScreen());
              }
            }
          },
        )
      ],
    );
  }
}
