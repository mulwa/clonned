//Checks if user is logged in or authenticating

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Anonymous
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  String accountType;
  Status _status = Status.Uninitialized;
  bool checkingAccountType;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  Future<String> signIn(
      String email, String password, String accountType) async {
    try {
      _status = Status.Authenticating;
      accountType = accountType;
      checkingAccountType = true;
      notifyListeners();

      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (result == null || result.user == null)
        return onError("No account");

      final doc = await Firestore.instance
          .collection(accountType == "u2" ? "users" : "realUsers")
          .document(result.user.uid)
          .get();

      if (doc.data == null ||
          doc.data['userType'] != accountType ||
          doc.data["banned"] == 1) {
        await _auth.signOut();
        return onError("Wrong acc type");
      }

      checkingAccountType = false;
      _user = result.user;
      _status = Status.Authenticated;
      notifyListeners();
      return null;
    } catch (error) {
      String errorMessage = "";
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = error.toString();
      }

      print(errorMessage);
      return onError(errorMessage);
    }
  }

  String onError(String error) {
    accountType = null;
    _status = Status.Unauthenticated;
    notifyListeners();
    checkingAccountType = false;
    return error;
  }

  Future<bool> signInAnonymously(String accountType) async {
    try {
      _status = Status.Authenticating;
      accountType = accountType;
      await _auth.signInAnonymously();
      return true;
    } catch (e) {
      _status = Status.Anonymous;
      return false;
    }
  }

  Future signOut() async {
    await _auth
        .signOut()
        .catchError((error, stacktrace) => print("$error : $stacktrace"))
        .then((value) {
      _status = Status.Unauthenticated;
      notifyListeners();
    });
  }

  void _onAuthStateChanged(FirebaseUser firebaseUser) {
    print("checking $checkingAccountType");

    if (checkingAccountType == null) checkingAccountType = false;

    if (checkingAccountType) {
      _status = Status.Authenticating;
    } else if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }

    notifyListeners();
  }
}