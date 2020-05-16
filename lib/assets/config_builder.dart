import 'package:get/get.dart';

class ConfigsController extends GetController {
  static ConfigsController get to => Get.find(); // add this line
  String s3BucketUrl;
  String s3Bucket;
  String s3Id;
  String s3Key;
  String apiUrl;
  String serviceKey;
  String apiGwKey;
  String googleMapsKey;
  void setS3Credentials({String id, String key, String url, String bucket}) {
    s3BucketUrl = url;
    s3Bucket = bucket;
    s3Id = id;
    s3Key = key;
    update(this);
  }

  void setApiKeys({String url, String gwKey, String serKey, String mapsKey}) {
    apiUrl = url;
    apiGwKey = gwKey;
    serviceKey = serKey;
    googleMapsKey = mapsKey;
    update(this);
  }
}
