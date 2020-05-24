import 'dart:async';

import 'package:flutter/material.dart';
import 'package:g2hv1/assets/user.dart';
import 'package:g2hv1/assets/user_builder.dart';
import 'package:g2hv1/screens/home_screen.dart';
import 'package:g2hv1/services/network.dart';
import 'package:g2hv1/widgets/animated_pin.dart';
import 'package:g2hv1/widgets/app_button.dart';
import 'package:g2hv1/widgets/app_progress_dialog.dart';
import 'package:g2hv1/widgets/common.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:g2hv1/services/location.dart';
import 'package:g2hv1/constants.dart';
import 'package:g2hv1/services/data_store.dart' as ds;
import 'dart:convert';
import 'package:g2hv1/enums.dart';
import 'dart:developer' as logger;

class UserProfileSetup extends StatefulWidget {
  final mobileNumber;
  final UserUpdateMode userUpdateMode;
  UserProfileSetup({this.mobileNumber, @required this.userUpdateMode});
  @override
  _UserProfileSetupState createState() => _UserProfileSetupState();
}

class _UserProfileSetupState extends State<UserProfileSetup> {
  Future<CameraPosition> currentCameraPositionFuture;
  Future<bool> loadingUserProfileComplete;
  CameraPosition _cameraPosition;

  bool pageInIt = false;

  User user;

  UserUpdateMode userUpdateMode;
  PinState pinState;

  String mobileNumber = '';
  String city = '';
  var userNameTextEditController = TextEditingController();

  CameraPosition cameraPosition;
  DeviceLocation location = DeviceLocation();
  Completer<GoogleMapController> _googleMapController = Completer();

  @override
  void initState() {
    pageInIt = true;
    city = 'Loading..';
    mobileNumber =
        widget.mobileNumber == null ? 'Loading...' : widget.mobileNumber;
    userUpdateMode = widget.userUpdateMode;
    logger.log(
        'Page Init Called: mobileNumber=$mobileNumber, userUpdateMode=$userUpdateMode, pageInIt: $pageInIt',
        name: 'Widget Tree');
    currentCameraPositionFuture = getCurrentCameraPosition();

    super.initState();
  }

  Future<CameraPosition> getCurrentCameraPosition() async {
    if (userUpdateMode == UserUpdateMode.Existing) {
      // We check if user exists in the system before resetting the location
      // to GPS location and then setup initial camera position user profile coordinates
      if (pageInIt == true) {
        var json = jsonDecode(await ds.readUserPref(key: 'user'));
        //loadingUserProfileComplete = true as Future<bool>;
        logger.log('User Profile read from device: $json');
        if (json.toString() != "0") {
          user = User.fromJson(json);
          mobileNumber = user.mobileNumber;
          userNameTextEditController.text = user.userProfile.name;
          city = user.userProfile.cities[0];
          if (user.userProfile.location.lat == 0.0)
            return await getGpsLocation();
          _cameraPosition = CameraPosition(
            target: LatLng(
                user.userProfile.location.lat, user.userProfile.location.lon),
            zoom: 16.0,
          );
          logger.log(
              'Camera position set to user profile coordinates: $_cameraPosition');
          pageInIt = false;
          return _cameraPosition;
        }
      }
    }
    return await getGpsLocation();
  }

  Future<CameraPosition> getGpsLocation() async {
    DeviceLocation lc = DeviceLocation();
    await lc.getCurrentLocation();
    _cameraPosition = CameraPosition(
      target: LatLng(lc.latitude, lc.longitude),
      zoom: 16.0,
    );
    logger.log(
        'Camera position set to current location coordinates: $_cameraPosition');
    return _cameraPosition;
  }

  Widget getBackButton() {
    return userUpdateMode == UserUpdateMode.Existing
        ? GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
            ),
            onTap: () {
              Get.back();
            },
          )
        : null;
  }

  Future saveUserProfile() async {
    AppProgressDialog progressDialog =
        AppProgressDialog(context: context, text: 'Saving..');
    progressDialog.show();
    var request = '''
      {"app-api-key": "test-key",
        "request": {
          "mobile-number": "$mobileNumber", 
          "user-type": "$kUserType", 
          "profile": {
            "name": "${userNameTextEditController.text}", 
            "location": {
              "lat":${_cameraPosition.target.latitude}, 
              "lon": ${_cameraPosition.target.longitude}
              }, 
            "cities": ["$city"]
          }
        }
      }''';
    logger.log('User Profile PUT Request: $request');

    NetworkHelper nw = NetworkHelper();
    var response = await nw.putData(endpoint: '/user', data: request);
    User user = User.fromJson(response);
    UserController.to.initUser(response);
    user.save();
    progressDialog.hide();

    // This ensures keyboard is retracted!
    FocusScope.of(context).unfocus();

    Get.offAll(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    logger.log('Page build method called', name: 'Widget Tree');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          kAppBarTextUserProfileSettings,
        ),
        leading: getBackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            //child: Text('hello'),
            child: userInfo(),
          ),
          Expanded(
            child: Center(
              child: Stack(
                children: <Widget>[
                  FutureBuilder(
                    future: currentCameraPositionFuture,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return Center(child: AppProgressIndicator());
                        case ConnectionState.done:
                          logger.log(
                              'Initializing map with camera position: ${snapshot.data}');
                          return googleMap(snapshot.data);
                        default:
                          return Center(child: AppProgressBroken());
                      }
                    },
                  ),
                  _defaultPinBuilder(pinState),
                  Center(
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppIconButton(
              buttonText: kUserProfileButtonTextSave,
              buttonIcon: kIconSave,
              onPressed: () async {
                saveUserProfile();
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }

  Widget userInfo() {
    logger.log('Initializing User Info Widget', name: 'Widget Tree');
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.phone),
            SizedBox(
              width: 10.0,
            ),
            Text(mobileNumber,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
          ],
        ),
        Row(
          children: <Widget>[
            Text(kUserProfileTextName,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              width: 20.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: AppTextField(textEditor: userNameTextEditController),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(kUserProfileCityName,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              width: 20.0,
            ),
            Text(
              city,
            ),
          ],
        ),
      ],
    );
  }

  Widget googleMap(CameraPosition localCameraPosition) {
    logger.log('Initializing Google Map Widget', name: 'Widget Tree');
    logger.log('Local camera position: $localCameraPosition');
    logger.log('Current camera position: $_cameraPosition');
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition: localCameraPosition,
      zoomControlsEnabled: true,
      onMapCreated: (GoogleMapController controller) async {
        _googleMapController.complete(controller);
        String _city = await getCityFromCoordinates(
            lat: localCameraPosition.target.latitude,
            lon: localCameraPosition.target.longitude);
        setState(() {
          pinState = PinState.Idle;
          city = _city;
        });
      },
      onCameraMove: (val) {
        setState(() {
          pinState = PinState.Dragging;
          cameraPosition = val;
        });
      },
      onCameraIdle: () async {
        logger.log('Camera position when camera Idle: $cameraPosition');
        if (cameraPosition != null) {
          String _city = await getCityFromCoordinates(
              lat: cameraPosition.target.latitude,
              lon: cameraPosition.target.longitude);
          setState(() {
            _cameraPosition = cameraPosition;
            pinState = PinState.Idle;
            city = _city;
            logger.log('Camera position set to : $cameraPosition');
          });
        }
      },
    );
  }

  Future<String> getCityFromCoordinates({double lat, double lon}) async {
    final String request = '''
        { 
          "app-api-key": "$kAppApiKey", 
          "request": { 
            "mobile-number": "$mobileNumber", 
            "lat": $lat, 
            "lon": "$lon" 
          }
        }
        ''';
    logger.log('City Name GET Request: $request');
    NetworkHelper nw = NetworkHelper();
    var response = await nw.postData(endpoint: '/geo/location', data: request);
    return (response['city'] != null) ? response['city'] : null;
  }

  Widget _defaultPinBuilder(PinState state) {
    if (state == PinState.Preparing) {
      return Container();
    } else if (state == PinState.Idle) {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.shopping_cart, size: 36, color: Colors.black),
                SizedBox(height: 42),
              ],
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(
                    child: Icon(Icons.shopping_cart,
                        size: 36, color: Colors.black)),
                SizedBox(height: 42),
              ],
            ),
          ),
        ],
      );
    }
  }
}
