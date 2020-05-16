import 'package:g2hv1/services/data_store.dart' as ds;
import 'dart:convert';
import 'package:g2hv1/assets/location.dart';

class User {
  String mobileNumber;
  String userType;
  UserProfile userProfile;
  User({this.mobileNumber, this.userType, this.userProfile});

  factory User.fromJson(dynamic json) {
    return User(
        mobileNumber: json['mobile-number'] as String,
        userType: json['user-type'] as String,
        userProfile: UserProfile.fromJson(json['profile']));
  }

  void save() {
    ds.saveUserPref(key: 'user', value: jsonEncode(toJson()));
  }

  Map<String, dynamic> toJson() => {
        'mobile-number': this.mobileNumber,
        'user-type': this.userType,
        'profile': this.userProfile.toJson()
      };

  @override
  String toString() {
    return '{ "mobile-number": "${this.mobileNumber}", "user-type": "${this.userType}", "profile": ${this.userProfile}}';
  }
}

class UserProfile {
  final String name;
  final String title;
  final List<String> cities;
  final Location location;
  UserProfile({
    this.name,
    this.location,
    this.title,
    this.cities,
  });
  factory UserProfile.fromJson(dynamic json) {
    List<String> _cities =
        json['cities'] != null ? List.from(json['cities']) : null;
    return UserProfile(
        name: json['name'] as String,
        location: Location.fromJson(json['location']),
        title: json['title'] as String,
        cities: _cities);
  }

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'location': this.location.toJson(),
        'title': this.title,
        'cities': this.cities
      };

  @override
  String toString() {
    return '{ "name": "${this.name}", "location": ${this.location}, "title": "${this.title}", "cities": ${this.cities}}';
  }
}

//main() {
//  String objText = '{"name": "bezkoder", "age": 30}';
//  String nestedUser =
//      '{"user-type":"seller","mobile-number":"+94773925720","profile":{"name":"User X","location":{"lat":6.908525949046337,"lon":79.92170921759156},"title":"Name of the shop","cities":["Battaramulla","Koswatta","Udumulla"]},"status":"active","code":3902}';
//  String nestedObjText =
//      '{"title": "Dart Tutorial", "description": "Way to parse Json", "author": {"name": "bezkoder", "age": 30}}';
//
//  User user = User.fromJson(jsonDecode(nestedUser));
//  //print(user.toString());
//  user.save();
//  print(ds.readUserPref(key: 'user'));
//  //Tutorial tutorial = Tutorial.fromJson(jsonDecode(nestedObjText));
//}
