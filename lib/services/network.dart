import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:g2hv1/common_functions.dart';
import 'package:g2hv1/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as logger;

enum RequestType { GET, POST, PUT, DELETE }

class NetworkHelper {
  String _url;
  NetworkHelper({String url}) {
    if (url != null) {
      _url = url;
    } else {
      _url = kDefaultApiBaseUrl;
    }
  }

  Future<dynamic> getData({@required String endpoint}) async {
    return await _request(
        requestType: RequestType.GET, endpoint: endpoint, data: null);
  }

  Future<dynamic> postData({@required String endpoint, var data}) async {
    return await _request(
        requestType: RequestType.POST, endpoint: endpoint, data: data);
  }

  Future<dynamic> putData({@required String endpoint, var data}) async {
    return await _request(
        requestType: RequestType.PUT, endpoint: endpoint, data: data);
  }

  Future<dynamic> _request({
    @required RequestType requestType,
    @required String endpoint,
    @required var data,
  }) async {
    String url = _url + endpoint;
    var headers = {"Content-type": "application/json", "x-api-key": kAppGwKey};
    http.Response response;
    logger.log('calling the url: $url, request type: $requestType');
    logger.log('request body: $data');
    try {
      switch (requestType) {
        case RequestType.POST:
          response = await http.post(url, body: data, headers: headers);
          break;
        case RequestType.PUT:
          response = await http.put(url, body: data, headers: headers);
          break;
        case RequestType.DELETE:
          response = await http.delete(url, headers: headers);
          break;
        case RequestType.GET:
          response = await http.get(url, headers: headers);
          break;
      }
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        logger.log('Response: ${response.body}');
        return jsonData;
      } else {
        logger.log(
            'http request returned non successful http code: ${response.statusCode}');
        logger.log('response body of the error response ${response.body}');
        throw new Exception(
            'http request returned non successful http code: ${response.statusCode}');
      }
    } catch (e) {
      showAlertDialog(
          error: e.toString(),
          errorDetails:
              'Looks like application is having troubles reaching Internet services!');
    }
  }
}
