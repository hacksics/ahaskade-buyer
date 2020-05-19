import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:g2hv1/assets/config_builder.dart';
import 'package:g2hv1/common_functions.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

final kS3ImageBucketUrl = ConfigsController.to.s3BucketUrl;
final kS3ImageBucket = ConfigsController.to.s3Bucket;
final kS3AccessKey = ConfigsController.to.s3Id;
final kS3SecretKey = ConfigsController.to.s3Key;
final kS3BucketRegion = 'us-east-1';

final kAppApiKey = ConfigsController.to.serviceKey;
final kAppGwKey = ConfigsController.to.apiGwKey;
final kDefaultApiBaseUrl = ConfigsController.to.apiUrl;
final kGoogleMapsKey = ConfigsController.to.googleMapsKey;

final kUserType = 'buyer';
final kCurrencySymbol = 'Rs.';
final kLocale = 'si';

final Color kLoadingBodyBackground = Color(0x1D004445);
final Color kButtonBodyColor = Colors.white;
final Color kButtonTextColor = Colors.black;
final Color kColorBackgroundWithOpacity =
    Colors.lightBlueAccent.withOpacity(0.05);

// text for labels and buttons
final String kButtonTextRequestCode = 'Request Code'.tr();
final String kTextEnterYourMobile = 'Enter your mobile number to continue'.tr();
final String kTextEnter4DigitCode = 'Enter the 4 digit code you received'.tr();
final String kButtonTextOtpSubmit = 'Validate'.tr();

// app bar constants
final kAppBarTextUserProfileSettings = 'User Profile Settings'.tr();

final Color kCardColor = Colors.black12;

String formatDoubleToPrice(double price) {
  return '${NumberFormat.currency(locale: kLocale, symbol: kCurrencySymbol).format(price)}';
}

AppBar getWhiteAppBar(String title) {
  return AppBar(
    title: Text(title, style: TextStyle(color: Colors.black)),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  );
}

//
// text for labels and buttons
Future invalidPinDialog() {
  return showSimpleAlertDialog(
      title: 'Invalid PIN',
      details: 'You\'ve entered ' +
          'incorrect PIN. Please check the SMS you\'ve recieved and enter the correct PIN');
}

Future invalidPhoneDialog() {
  return showSimpleAlertDialog(
      title: 'Invalid Phone Number',
      details: 'Looks like you\'ve entered invalid phone number!');
}

// Icons
const kIconOpenOrder = FeatherIcons.shoppingCart;
const kIconShippedOrder = FeatherIcons.truck;
const kIconDeliveredOrder = FeatherIcons.shoppingBag;
const kIconDeleteOrder = FeatherIcons.trash2;
const kIconSettings = FeatherIcons.settings;
const kIconHome = FeatherIcons.home;
const kIconList = FeatherIcons.list;
const kIconAddLocation = Icons.add_location;
const kIconPhone = FeatherIcons.phone;
const kIconSave = FeatherIcons.save;
const kIconDone = FeatherIcons.check;
const kIconAdd = FeatherIcons.plus;
const kIconCamera = FeatherIcons.camera;
const kIconPhotos = FeatherIcons.image;

// popup menu
final String kMenuTextUserProfile = 'My Profile'.tr();
final String kMenuTextAbout = 'About'.tr();
final String kMenuTextLogout = 'Logout'.tr();

// home screen
final String kAppBarTextHomeScreen = 'Ahaskade Buyer'.tr();
final String kButtonTextNewOrder = 'New Order'.tr();
final String kNavBarTextOpenOrders = 'New'.tr();
final String kNavBarTextScheduledOrders = 'Scheduled'.tr();
final String kNavBarTextCompletedOrders = 'Completed'.tr();
final String kNavBarTextDeletedOrders = 'Archived'.tr();

final String kUserProfileTextName = 'Name'.tr();
final String kUserProfileCityName = 'City'.tr();
final String kUserProfileButtonTextSave = 'SAVE'.tr();
