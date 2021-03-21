//This is used for calculating the distance

import 'package:flutter/cupertino.dart';
import 'package:connectivity/connectivity.dart';


class NetworkCheck {
  Future<bool> check() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }


}
