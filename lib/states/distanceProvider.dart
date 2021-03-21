//Helps calculating distance
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart';

class distanceProvider{
  Position _userPosition;
  double _lat;

  Position get userPosition  => _userPosition;
  double get lat => _lat;


  getPosition() async {
    try{
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(serviceEnabled) {
        Position position = await Geolocator
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: false);
        _userPosition = position;
        //print("DEBUG: FIRST IF CHECK DISTANCEPRIVDER " + userPosition.toString());
      }
      else {
        await Geolocator.openLocationSettings().then((value) async{
          print("HERE + $value");
          if(value){
            await Geolocator.isLocationServiceEnabled().then((value)async {
              if(value){
                print("HERE2 + $value");
              }
              else{
                await Geolocator.isLocationServiceEnabled().then((value) {
                  print("HERE2 + $value");
                });
              }
            });
          }
        });
      }
    } catch(e){
      print("Location error: $e");
    }
  }
  Future initialization()async{
    try{
      await getPosition();
      return true;
    }catch(e){
      return false;
    }
  }
}