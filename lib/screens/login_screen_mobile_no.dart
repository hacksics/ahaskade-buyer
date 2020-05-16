import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:g2hv1/assets/user_builder.dart';
import 'package:g2hv1/screens/otp_code_entry.dart';
import 'package:g2hv1/widgets/common.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:json_string/json_string.dart';
import '../services/network.dart';
import '../constants.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text.dart';
import '../widgets/app_progress_dialog.dart';
import 'package:g2hv1/widgets/app_alert_dialog.dart';
import 'package:g2hv1/assets/user.dart';
import 'package:g2hv1/widgets/main_screen_canvas.dart';
import 'dart:developer' as logger;

class MobileNumberInputScreen extends StatefulWidget {
  @override
  _MobileNumberInputScreenState createState() =>
      _MobileNumberInputScreenState();
}

class _MobileNumberInputScreenState extends State<MobileNumberInputScreen> {
  PhoneNumber phone;
  bool isValidPhone = false;
  bool registrationRequired = true;
  User user;

  Future<void> submitNumber() async {
    if (isValidPhone == false) {
      invalidPhoneDialog();
      return;
    }
    var requestBody = '''
    {
      "app-api-key": "test-key",
      "request": {
        "mobile-number": "$phone"
      }
    }
    ''';

    NetworkHelper nw = NetworkHelper();
    AppProgressDialog apd =
        AppProgressDialog(text: 'Loading..', context: context);
    await apd.show();
    var response = await nw.postData(endpoint: '/user', data: requestBody);
    if (response['profile'] != null) {
      // ensure that we update the local data store with cloud user profile
      user = User.fromJson(response);
      user.save();
      UserController.to.initUser(response);
      registrationRequired = false;
    } else {
      logger.log(
          'user profile does not exists in cloud. need to route to user profile setup section');
    }
    await apd.hide();
    Get.offAll(OtpInputScreen(
      otpCode: response['code'],
      mobileNumber: phone.toString(),
      registrationRequired: registrationRequired,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MainScreenCanvas(
      children: <Widget>[
        Text(
          kTextEnterYourMobile,
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: InternationalPhoneNumberInput(
            // TODO: this widget is not refactored given that it may not be reused again
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
            inputDecoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Phone Number',
                hintStyle: TextStyle(color: Colors.black38),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.none,
                )),
            initialCountry2LetterCode: 'LK',
            selectorType: PhoneInputSelectorType.DIALOG,
            autoValidate: true,
            onInputChanged: (PhoneNumber number) {
              phone = number;
            },
            onSubmit: () async {
              await submitNumber();
            },
            onInputValidated: (bool value) {
              isValidPhone = value;
            },
          ),
        ),
        SizedBox(height: 20.0),
        AppTextButton(
          buttonText: kButtonTextRequestCode,
          onPressed: () async {
            await submitNumber();
          },
        ),
      ],
    );
  }
}
