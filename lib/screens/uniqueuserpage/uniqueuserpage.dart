import 'package:cloneapp/states/UserRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'package:cloneapp/screens/mainlist.dart';


class uniqueUserPage extends StatefulWidget {
  @override
  _uniqueUserPageState createState() => _uniqueUserPageState();
}

class _uniqueUserPageState extends State<uniqueUserPage> {
  final databaseReference = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseUser user;
  String userType;
  UserRepository userRepository;


  @override
  void initState() {
    super.initState();

    userRepository = Provider.of<UserRepository>(context, listen: false);
    userType = userRepository.accountType;
    user = userRepository.user;


  }

  Widget body(){
    return StreamBuilder(
      stream:  Firestore.instance
          .collection("users")
          .document(user.uid)
          .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot){
          if (!snapshot.hasData)
            return Center(
              child: new Container(
                width: 100,
                height: 100,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text("Loading")],
                ),
              ),
            );
          DocumentSnapshot ds = snapshot.data;
          return Column(
            children: [
              Text("This is the u2 profile page"),
              Text("Name: " +ds["u2a"]),
              InkWell(
                onTap: () async {
                  await accountTypeAccount.remove("type");
                  //accountType.remove("stringValue");
                  await Provider.of<UserRepository>(context, listen: false)
                      .signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },

                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text("Sign Out"),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => mainlist()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text("Go to mainlist"),
                ),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: body(),
    );
  }
}
