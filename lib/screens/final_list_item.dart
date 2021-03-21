import 'package:android_intent/android_intent.dart';
import 'package:cloneapp/models/document.dart';
import 'package:cloneapp/states/data_bloc.dart';
import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:cloneapp/states/UserRepository.dart';


import 'package:platform/platform.dart';
import 'package:provider/provider.dart';

class finalListItem extends StatefulWidget {
  final Document document;

  const finalListItem({Key key, this.document}) : super(key: key);
  @override
  _finalListItemState createState() => _finalListItemState();
}

class _finalListItemState extends State<finalListItem> {
  UserRepository user;
  DataBloc bloc;



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 120,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
      Text(
      widget.document
          .doc["u2a"] ??
      "No rU1")
            ],
          )
        ],
      ),
    );
  }
}
