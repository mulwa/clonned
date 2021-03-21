import 'package:cloneapp/main.dart';
import 'package:cloneapp/models/document.dart';
import 'package:cloneapp/screens/final_list_item.dart';
import 'package:cloneapp/screens/mainlist.dart';
import 'package:cloneapp/states/UserRepository.dart';
import 'package:cloneapp/states/data_bloc.dart';
import 'package:cloneapp/states/distanceProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:cloneapp/states/data_bloc.dart';

class uniqueUserPageUser extends StatefulWidget {
  @override
  _uniqueUserPageUserState createState() => _uniqueUserPageUserState();
}

class _uniqueUserPageUserState extends State<uniqueUserPageUser> {
  final databaseReference = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserRepository userRepository;
  DataBloc bloc;
  FirebaseUser user;
  String userType;

  dynamic name;
  dynamic points;

  @override
  void initState() {
    super.initState();
    bloc = Provider.of<DataBloc>(context, listen: false);
    userRepository = Provider.of<UserRepository>(context, listen: false);
    user = userRepository.user;
    userType = userRepository.accountType;

    name = getName();
  }

  Future<String> getName() async {
    final res = await Firestore.instance
        .collection('realUsers')
        .document(user.uid)
        .get();

    return "Value from database: " + res["u1a"];
  }

  Widget body() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black, size: 17),
          actions: <Widget>[],
          floating: true,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Column(
              children: [
                FutureBuilder(
                    future: name,
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 35.0, right: 35, top: 55, bottom: 40),
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            snapshot.data ?? "Welcome",
                                          )),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await accountTypeAccount.remove("type");
                                      await Provider.of<UserRepository>(context,
                                              listen: false)
                                          .signOut();

                                      //Navigator.pushReplacement(context,
                                      //    MaterialPageRoute(builder: (context) => MyApp()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text("Sign Out"),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  mainlist()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text("Go to mainlist"),
                                    ),
                                  )
                                ],
                              ),
                              Spacer(
                                flex: 8,
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.white,
                                  width: 150,
                                  height: 110,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body());
  }
}
