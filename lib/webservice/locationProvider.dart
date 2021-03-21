import 'dart:async';
import 'dart:math';

import 'package:cloneapp/models/userLocation.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider {
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();

  Stream<UserLocation> get locationStream => _locationController.stream;

  StreamController<bool> _isLocationEnabled =
      StreamController<bool>.broadcast();

  Stream<bool> get isLocationEnabled => _isLocationEnabled.stream;

  LocationProvider() {
    print('location provider constructor');
    Timer.periodic(Duration(seconds: 5), (t) async {
      print('checking location');
      _isLocationEnabled.add(await Geolocator.isLocationServiceEnabled());
    });
    getLocationUpdates();
  }

  Future getLocationUpdates() async {
    _isLocationEnabled.stream.listen((bool event) {
      if (event) {
        Geolocator.getPositionStream(intervalDuration: Duration(seconds: 5))
            .listen((Position position) {
          print(position.latitude);
          if (position != null) {
            _locationController.add(UserLocation(
                latitude: position.latitude, longitude: position.longitude));
          }
        });
      } else {
        Geolocator.openLocationSettings();
      }
    });
  }
}
