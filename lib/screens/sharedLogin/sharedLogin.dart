//The shared login page - the page you see when the app opens you are not logged in

import 'dart:ui';

import 'package:cloneapp/models/userLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloneapp/main.dart';
import 'package:cloneapp/resetPassword/resetPassword.dart';
import 'package:cloneapp/screens/SignupSignIn/setupScreen1.dart';
import 'package:cloneapp/screens/SignupSignIn/signupscreen.dart';
import 'package:cloneapp/screens/createUser/signUp.dart';
import 'package:cloneapp/screens/uniqueuserpage/uniqueuserpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/offerings_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mainlist.dart';
import 'package:cloneapp/states/UserRepository.dart';

class sharedLogin extends StatefulWidget {
  @override
  _sharedLoginState createState() => _sharedLoginState();
}

class _sharedLoginState extends State<sharedLogin> {
  //NEW
  String _login;
  bool _loggedIn;

  FirebaseAuth _auth;

  bool _isSwitched = false;
  bool _isVisible;

  void showForm() {
    setState(() {
      _isVisible = _isSwitched;
    });
  }

  TextEditingController _u1E;
  TextEditingController _u1P;
  final _u1fK = GlobalKey<FormState>();
  final _u1K = GlobalKey<ScaffoldState>();

  TextEditingController _u2E;
  TextEditingController _u2P;
  final _u2fK = GlobalKey<FormState>();
  final _u2K = GlobalKey<ScaffoldState>();

  int tap = 0;

  @override
  void initState() {
    super.initState();

    _u1E = TextEditingController(text: "");
    _u1P = TextEditingController(text: "");
    _u2E = TextEditingController(text: "");
    _u2P = TextEditingController(text: "");
  }

  Widget showswitch(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    UserLocation userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
        body: Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/ClickHere.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Location: Lat${userLocation?.latitude}, Long: ${userLocation?.longitude}'),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Login CloneApp",
                          style: TextStyle(
                              fontFamily: "LatoBold",
                              fontSize: 40,
                              color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      child: Text(
                        "Sign in U1",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          _isVisible = true;
                        });
                      },
                    ),
                    MaterialButton(
                      child: Text("Sign in U2",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          _isVisible = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  accountTypeAccount.setString('type', 'u3');
                  if (!await user.signInAnonymously("u3"))
                    _u1K.currentState.showSnackBar(SnackBar(
                      content: Text("FOUT"),
                    ));
                },
                child:
                    Text('Sign in U3', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget u1Login(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _u1K,
      backgroundColor: Colors.white,
      body: Form(
        key: _u1fK,
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: InkWell(
                    onTap: () async {
                      await accountTypeAccount
                          .remove("type")
                          .then((value) => Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            MyApp()),
                              ));
                    },
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/ClickHere.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 320,
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(40.0, 90.0, 20.0, .0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sign in U1",
                              style: TextStyle(
                                  fontSize: 24, fontFamily: "LatoBold"),
                            ),
                            Text(
                              "Log in to proceed",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "LatoRegular",
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, .0),
                  child: new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    controller: _u1E,
                    decoration: new InputDecoration(
                        hintText: 'u1E',
                        icon: new Icon(
                          Icons.mail,
                          color: Colors.grey,
                        )),
                    validator: (value) => (value.isEmpty) ? "Enter u1E" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 10),
                  child: new TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: _u1P,
                    decoration: new InputDecoration(
                        hintText: 'Password',
                        icon: new Icon(
                          Icons.security,
                          color: Colors.grey,
                        )),
                    validator: (value) =>
                        (value.isEmpty) ? "Enter email" : null,
                    obscureText: true,
                  ),
                ),
                user.status == Status.Authenticating
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 320,
                                child: Material(
                                  child: MaterialButton(
                                    height: 35,
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    onPressed: () async {
                                      accountTypeAccount.setString(
                                          'type', 'u1');
                                      if (_u1fK.currentState.validate()) {
                                        String result = await user.signIn(
                                            _u1E.text, _u1P.text, "u1");
                                        if (result != null)
                                          _u1K.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text("FOUT: $result"),
                                          ));
                                      }
                                    },
                                    child: Text(
                                      "Sign un U1",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: "LatoBold"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget u2Login(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _u2K,
      backgroundColor: Colors.white,
      body: Form(
        key: _u2fK,
        child: ListView(
          children: <Widget>[
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: InkWell(
                      onTap: () async {
                        await accountTypeAccount.remove("type").then((value) =>
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            MyApp())));
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/ClickHere.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 320,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(40.0, 90.0, 40.0, .0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sign in U2",
                                style: TextStyle(
                                    fontSize: 24, fontFamily: "LatoBold"),
                              ),
                              Text(
                                "Log in to proceed",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "LatoRegular",
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*
                  MaterialButton(
                    child: Text("Wijzig naar user"),
                    onPressed: () {
                      setState(() {
                        _isVisible = true;
                      });
                    },
                  ),

                   */
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, .0),
                    child: new TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      controller: _u2E,
                      decoration: new InputDecoration(
                          hintText: 'Email',
                          icon: new Icon(
                            Icons.mail,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          (value.isEmpty) ? "Enter email" : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 10),
                    child: new TextFormField(
                      maxLines: 1,
                      autofocus: false,
                      controller: _u2P,
                      decoration: new InputDecoration(
                          hintText: 'Wachtwoord',
                          icon: new Icon(
                            Icons.security,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          (value.isEmpty) ? "Geef wachtwoord in" : null,
                      obscureText: true,
                    ),
                  ),
                  user.status == Status.Authenticating
                      ? Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 320,
                                  child: Material(
                                    child: MaterialButton(
                                      height: 35,
                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      onPressed: () async {
                                        accountTypeAccount.setString(
                                            'type', 'u2');
                                        if (_u2fK.currentState.validate()) {
                                          String result = await user.signIn(
                                              _u2E.text, _u2P.text, "u2");
                                          if (result != null)
                                            _u2K.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text("FOUT : $result"),
                                            ));
                                        }
                                      },
                                      child: Text(
                                        "Sign in U2",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: "LatoBold"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isVisible == true || accountTypeAccount.get("type") == "u1") {
      return u1Login(context);
    } else if (_isVisible == false || accountTypeAccount.get("type") == "u2") {
      return u2Login(context);
    } else {
      return showswitch(context);
    }
  }

  @override
  void dispose() {
    _u1E.dispose();
    _u1P.dispose();

    _u2E.dispose();
    _u2P.dispose();
    super.dispose();
  }
}
