//This is used for calculating the distance


import 'dart:convert';

import 'package:http/http.dart' as http;

import 'network_check.dart';
import 'webservice_constants.dart';

typedef JSONResponseParser = dynamic Function(Map<String, dynamic> json);

class WebserviceHelper {
  // next three lines makes this class a Singleton
  static WebserviceHelper _instance = WebserviceHelper.internal();

  static const int WEB_SUCCESS_STATUS_CODE = 200;
  static const int ERROR_STATUS_CODE = 401;

  WebserviceHelper.internal();

  factory WebserviceHelper() => _instance;

  /// Get API call
  Future<Map<String, dynamic>> get({
    final String url,
    Map<String, String> headers,
    final dynamic Function(bool) onError,
  }) async {
    final bool isNetworkAvailable = await NetworkCheck().check();
    if (isNetworkAvailable) {
      final http.Response response = await http.get(url);

      if (response != null) {
        Map<String, dynamic> jsonData;
        try {
          jsonData = jsonDecode(response.body);
        } catch (_) {}
        return jsonData;
      }
    }
    return onError != null ? onError(isNetworkAvailable) : null;
  }

  /// Post API call
  Future<dynamic> post(
      String url, {
        Map<String, String> headers,
        Map<String, String> params,
        body,
        encoding,
      }) async {
    final response = await http
        .post(url, headers: headers, body: body, encoding: encoding)
        .timeout(
        Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
        onTimeout: _onTimeOut);

    Map<String, dynamic> jsonData;
    try {
      jsonData = jsonDecode(response.body);
    } catch (_) {}

    return jsonData;
  }
  /// Put API call
  Future<dynamic> put(
      String url, {
        Map<String, String> headers,
        Map<String, String> params,
        body,
        encoding,
      }) async {
    final response = await http
        .put(url, headers: headers, body: body, encoding: encoding)
        .timeout(
        Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
        onTimeout: _onTimeOut);

    Map<String, dynamic> jsonData;
    try {
      jsonData = jsonDecode(response.body);
    } catch (_) {}

    return jsonData;
  }
  /// Put API call
  Future<dynamic> delete(
      String url, {
        Map<String, String> headers,
        Map<String, String> params,
      }) async {
    final response = await http
        .delete(url, headers: headers,)
        .timeout(
        Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
        onTimeout: _onTimeOut);

    Map<String, dynamic> jsonData;
    try {
      jsonData = jsonDecode(response.body);
    } catch (_) {}

    return jsonData;
  }

  Future<Map<String, String>> addConfigHeaders(
      Map<String, String> headers) async {
    //TODO:Need to return valid headers
  }

  http.Response _onTimeOut() {
    print("timeout");
    //TODO:Need to return valid timeout action
  }
}
