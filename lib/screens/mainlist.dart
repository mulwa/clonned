//Where the magic happens - The screen where the main list is built

import 'package:android_intent/android_intent.dart';
import 'package:async/async.dart';
import 'package:cloneapp/models/document.dart';
import 'package:cloneapp/screens/createUser/userHomePage.dart';
import 'package:cloneapp/screens/final_list_item.dart';
import 'package:cloneapp/screens/sharedLogin/sharedLogin.dart';
import 'package:cloneapp/screens/uniqueuserpage/uniqueuserpage.dart';
import 'package:cloneapp/states/data_bloc.dart';
import 'package:cloneapp/states/distanceProvider.dart';
import 'package:cloneapp/webservice/webservice_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:cloneapp/states/UserRepository.dart';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:platform/platform.dart';
import '../main.dart';
import 'SignupSignIn/signupscreen.dart';
import 'package:provider/provider.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';


class mainlist extends StatefulWidget {
  @override
  _mainlistState createState() => _mainlistState();
}

class _mainlistState extends State<mainlist> {

  UserRepository userRepository;
  FirebaseUser user;
  String userType;

  DataBloc bloc;
  Stream<List<Document>> stream;

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    bloc = Provider.of<DataBloc>(context, listen: false);
    stream = bloc.stream;
    whichTiles();

    // print('here outside async');
  }
  Widget homePage() {
    return prefix1.Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: StreamBuilder(
          stream: stream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Document>> snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.home),
                    color: Colors.white,
                    iconSize: 17,
                    onPressed: () {
                      if (accountTypeAccount.get("type") == "u1") navigateTou1Page();
                      if (accountTypeAccount.get("type") == "u2") navigateTou2Page();
                    },
                  ),
                  backgroundColor: Colors.green,
                  actions: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu, size: 30,color: Colors.white,),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                      ),
                    ),
                  ],
                  iconTheme: IconThemeData(color: Colors.black),
                  elevation: 0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CLONE",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "APP",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),

                endDrawer: Drawer(
                  elevation: 1,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.green,
                        ),
                        child: prefix1.Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <prefix1.Widget>[
                            FutureBuilder(
                                future: _getN(),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Text('none');
                                    case ConnectionState.active:
                                    case ConnectionState.waiting:
                                      return Text('waiting');
                                    case ConnectionState.done:
                                      if (snapshot.hasError) return Text('Test');
                                      return Text("Test " + snapshot.data.toString() ??
                                          Text(''));
                                  // You can reach your snapshot.data['url'] in here
                                  }
                                  return null; // unreachable
                                }),
                            Text(
                              'Menu/settings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await accountTypeAccount.remove("type");
                                //accountType.remove("stringValue");
                                await Provider.of<UserRepository>(context, listen: false)
                                    .signOut();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => MyApp()));
                              },
                              child: prefix1.Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text("Sign Out"),
                              ),
                            )
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: whichTiles(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Text('none');
                              case ConnectionState.active:
                              case ConnectionState.waiting:
                                return Text('waiting');
                              case ConnectionState.done:
                                if (snapshot.hasError) return Text('Welcome');
                                return snapshot.data;
                            // You can reach your snapshot.data['url'] in here
                            }
                            return null; // unreachable
                          }),
                    ],
                  ),
                ),
                body: FutureBuilder(
                  future: Future.delayed(Duration(seconds: 10), () {
                    return true;
                  }),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      print("DEBUG If" + snapshot.connectionState.toString());

                      return Center(
                        child: new Container(
                          width: 100,
                          height: 100,
                          child: new Column(
                            mainAxisAlignment: prefix1.MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      );
                    }
                    else {
                      print("DEBUG Else" + snapshot.connectionState.toString());
                      return Center(
                        child: new Container(
                          width: 200,
                          height: 100,
                          child: new Column(
                            mainAxisAlignment: prefix1.MainAxisAlignment.center,
                            children: [prefix1.Row(
                              mainAxisAlignment: prefix1.MainAxisAlignment.center,
                              children: [
                                Text("Nothing to show"),
                              ],
                            ),



                            ],
                          ),
                        ),
                      ); }
                  },
                ),
              );
            } else {
              return NotificationListener<ScrollNotification>(
                onNotification: (prefix1.ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent * 0.75) {
                    if (!bloc.loading) {
                      bloc.loadMore();
                      return true;
                    }
                  }
                  return false;
                },
                child: RefreshIndicator(
                  key: refreshIndicatorKey,
                  onRefresh: () async {
                    return refresh();
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        elevation: 1,
                        backgroundColor: Colors.green,
                        leading: IconButton(
                          icon: Icon(Icons.home),
                          color: Colors.white,
                          iconSize: 17,
                          onPressed: () {
                            if (accountTypeAccount.get("type") == "u1") navigateTou1Page();
                            if (accountTypeAccount.get("type") == "u2") navigateTou2Page();
                          },
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Clone",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "App",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        iconTheme: IconThemeData(color: Colors.white, size: 17),
                        actions: <Widget>[],
                        floating: true,
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return prefix1.Column(
                                children: [
                                  finalListItem(document: snapshot.data[index]),
                                  //Added duplicates to test list loading in pages
                                  // finalListItem(document: snapshot.data[index]),
                                  // finalListItem(document: snapshot.data[index]),
                                  // finalListItem(document: snapshot.data[index]),
                                ],
                              );
                            }, childCount: snapshot.data.length),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  //Futures
  Future _getN() async {
    //TODO: GEEFT NULL AAN
    print("DEBUG mainlist(): _getN result: " + userType.toString());
    //print(user.email.toString());
    if (accountTypeAccount.get("type") == "u1") {
      DocumentSnapshot userName = await Firestore.instance
          .collection('realUsers')
          .document(user.uid)
          .get();
      return userName['u1a'];
    } else if (accountTypeAccount.get("type") == "u2") {
      DocumentSnapshot userName =
      await Firestore.instance.collection('users').document(user.uid).get();
      return userName['u2a'];
    } else if (accountTypeAccount.get("type") == "u3") {
      return "masked man";
    }
  }

  Future refresh() async {
    print("refresh");

    if (!bloc.loading) {
      final provider = Provider.of<distanceProvider>(context, listen: false);
      await provider.getPosition();

      bloc.getData(provider.userPosition);
    }

    return waitWhile(() => bloc.loading);
  }

  Future waitWhile(bool test(), [Duration pollInterval = Duration.zero]) {
    var completer = new Completer();
    check() {
      if (!test()) {
        completer.complete();
      } else {
        new Timer(pollInterval, check);
      }
    }

    check();
    return completer.future;
  }

  Future whichTiles() async {
    if (accountTypeAccount.get("type") == "u1") {
      return Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('u1 profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => uniqueUserPageUser()));
            },
          ),
        ],
      );
    } else if (accountTypeAccount.get("type") == "u2") {
      return Column(
        mainAxisSize: prefix1.MainAxisSize.max,
        mainAxisAlignment: prefix1.MainAxisAlignment.spaceAround,
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Colors.blueAccent),
            title: Text('u2 profile'),
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => uniqueUserPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blueAccent),
            title: Text('Sign out'),
            onTap: () async {
              await accountTypeAccount.remove("type");
              //accountType.remove("stringValue");
              await userRepository.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
        ],
      );
    } else if (accountTypeAccount.get("type") == "u3") {
      return prefix1.Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Maak account!'),
            onTap: () async{
              await accountTypeAccount.remove("type");
              //accountType.remove("stringValue");
              await userRepository.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
              //navigateToSharedLogin();
            },
          ),
          ListTile(
              leading: Icon(Icons.person),
              title: Text('Log uit!'),
              onTap: () async {
                await accountTypeAccount.remove("type");
                //accountType.remove("stringValue");
                Provider.of<UserRepository>(context, listen: false).signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
              }),
        ],
      );
    } else {
      return Container();
    }
  }

  //Navigational buttons
  void navigateTou2Page() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => uniqueUserPage()));
  }

  void navigateTou1Page() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => uniqueUserPageUser()));
  }

  @override
  Widget build(prefix1.BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    user = userRepository.user;
    userType = userRepository.accountType;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        elevation: 1,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: prefix1.Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <prefix1.Widget>[
                  FutureBuilder(
                      future: _getN(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Text('none');
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return Text('waiting');
                          case ConnectionState.done:
                            if (snapshot.hasError) return Text('No Val');
                            return Text(snapshot.data.toString() ??
                                Text(''));
                        // You can reach your snapshot.data['url'] in here
                        }
                        return null; // unreachable
                      }),
                  Text(
                    'Menu/settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await accountTypeAccount.remove("type");
                      //accountType.remove("stringValue");
                      await Provider.of<UserRepository>(context, listen: false)
                          .signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: prefix1.Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text("Sign Out"),
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder(
                future: whichTiles(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('none');
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Text('waiting');
                    case ConnectionState.done:
                      if (snapshot.hasError) return Text('No Val');
                      return snapshot.data;
                  // You can reach your snapshot.data['url'] in here
                  }
                  return null; // unreachable
                }),
          ],
        ),
      ),
      body: homePage(),
    );
  }
}
