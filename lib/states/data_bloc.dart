import 'dart:async';

import 'package:cloneapp/states/distanceProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloneapp/models/document.dart';
import 'package:cloneapp/states/UserRepository.dart';
import 'package:cloneapp/states/distanceProvider.dart';
import 'package:cloneapp/webservice/webservice_helper.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class DataBloc {
  DataBloc(this.context) {
    _streamController = BehaviorSubject();
    _favouritePlacesController = BehaviorSubject();
    updateIsSubscribed();
    //TODO: if u1uHH() needed unlock function
    //u1uHH();
    //TODO: if u1uP() needed unlock function
    //u1uP();
    user = Provider.of<UserRepository>(context, listen: false);
  }

  //Output data streams
  StreamController<List<Document>> _streamController;

  StreamSink<List<Document>> get streamSink => _streamController.sink;

  Stream<List<Document>> get stream =>
      _streamController.stream.asBroadcastStream();

  StreamController<List<Document>> _favouritePlacesController;
  StreamSink<List<Document>> get favouritePlacesSink =>
      _favouritePlacesController.sink;
  Stream<List<Document>> get favouritePlaces =>
      _favouritePlacesController.stream.asBroadcastStream();

  List<Document> documents = [];
  List<Document> favourites = [];

  Timer timer;

  //Input data streams
  //SET DISTANCE
  BehaviorSubject<double> radius = BehaviorSubject<double>.seeded(50.0);
  Geoflutterfire geo;
  GeoFirePoint center;

  bool loading = false;
  bool updating = false;
  bool loadingFavourites = false;

  int lastItem = 0;
  int lastFavouriteItem = 0;

  BuildContext context;
  UserRepository user;
  distanceProvider provider;


  void getData(Position pos) async{

    //Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: false);
    //List of documents
    documents = [];

    //GeoFflutterfire object
    geo = Geoflutterfire();

    //Centerpoint for the query
    center = geo.point(latitude: pos.latitude, longitude: pos.longitude);

    //Calculates circle around the person and returns a list of List<DocumentSnapshot> snapshot
    radius.switchMap((rad) {
      var queryRef = Firestore.instance.collection('users');
      return geo.collection(collectionRef: queryRef).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    }).listen((List<DocumentSnapshot> snapshot) async {
      print("updating : $updating");

      if (updating) return;
      if (loading) return;

      loading = true;

      //Gets list from getList(snapshot) snapshot are the docs inside the queryRef
      //getList returns newList
      final list = getList(snapshot);

      //TODO: Figure out what this is
      for (int i = 0; i < list.length; i++) {
        if (documents.contains(list[i])) {
          int index = documents.indexOf(list[i]);
          await _getStatus(documents[index]);
          if (list[i].a11 != "3") {
            //TODO: Need a9 unlock this
            //_geta9
            //await _geta9(documents[index]);
            //TODO: Need a2anda3 unlock this
            //_geta2Anda3
            //await _geta2Anda3(documents[index]);
          }
        } else {
          await _getStatus(list[i]);
          if (list[i].a11 != "3") {
            //TODO: Need a9 unlock this
            //_geta9
            //await _geta9(list[i]);
            //TODO: Need a2anda3 unlock this
            //_geta2Anda3
            //await _geta2Anda3(list[i]);

            documents.add(list[i]);
          }
        }
      }

      //Comparing the value of document b.a1 to the document a.a1
      documents.sort((a, b) => b.a1.compareTo(a.a1));

      //The integer of the last document in the list
      //10 documents in documents lastItem = 10
      lastItem = documents.length;

      //If there are more items in the list then 5, set lastItem to 5
      if (documents.length > 5) lastItem = 5;

      //If i is smaller then listItem getDocumentInfo
      for (int i = 0; i < lastItem; i++) {
        //await _getTestItemFromFirestore(doc);
        await getDocumentInfo(documents[i]);
        //Adding the document with finished future to the stream
      }
      streamSink.add(documents.getRange(0, lastItem).toList());
      loading = false;
    });
  }


  //Gets the rest of document info
  Future getDocumentInfo(Document doc) async {
    //TODO: if a13 needed unlock this
    //await _geta13(doc);

    //TODO: If a7 needed unlock this
    //await _geta7(doc);

    //TODO: Is a8 needed? unlock this
    //await _geta8(doc);

    //TODO: is gD needed? unlock this
    //if (doc.a10 == null) await _gD(doc);
    //For testing
    doc.a10 = "1m";

    //TODO: Is a12 needed? unlock this
    //await _geta12(doc);
  }


  //TODO: is u1gF needed? Unlock this
  //u1gF


  //Loads more items
  void loadMore() async {
    if (lastItem == documents.length) return;

    int newLast = lastItem + 5;
    if (newLast > documents.length) lastItem = documents.length;

    loading = true;

    for (int i = lastItem; i < newLast; i++) {
      //await _getTestItemFromFirestore(doc);
      await getDocumentInfo(documents[i]);
      //Adding the document with finished future to the stream
    }
    streamSink.add(documents.getRange(0, newLast).toList());
    loading = false;
    lastItem = newLast;
  }

  bool isSubscribed(DocumentSnapshot doc) {
    final date = doc.data['subscribedUntil'];
    if (date == null) return false;

    try {
      DateTime d = DateTime.parse(date.toString()).toLocal();
      if (d.compareTo(DateTime.now().toLocal()) <= 0) {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }

  //Checks every  minute to see if anyone's subscription has expired
  updateIsSubscribed() {
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      int length = documents.length;
      for (Document doc in documents) {
        if (!isSubscribed(doc.doc)) documents.remove(doc);
      }

      if (documents.length != length) {
        streamSink.add(documents);
      }
    });
  }

  List<Document> getList(List<DocumentSnapshot> list) {
    List<Document> newList = [];



    for (DocumentSnapshot doc in list) {


      Document object = Document(doc: doc);

      final bool subscribed = isSubscribed(doc);
      if (!subscribed) continue;

      newList.add(object);
    }

    return newList;
  }

  //FUTURES
  //TODO: need a13 unlock this


  //TODO: Need a2 and a3 unlock _geta2Anda3
  //_geta2Anda3



  //TODO: is u1uHH needed unlock here
  //u1uHH

  //TODO: Is a7 needed? Enable this
  //_geta7


  //TODO: Is a8 needed? Enable this
  //_geta8

//TODO: Is a9 needed? Enable this
  //_geta9


//TODO: is u1uP needed? Enable this
  //u1uP


  //TODO: need gD unlock this
  //gD

  Future _getStatus(Document document) async {
    document.a11 = "1";
    //print((document.doc.documentID));
  }

  //TODO: Is a12 needed? Enable this

  void dispose() {
    _streamController.close();
    _favouritePlacesController.close();
  }
}