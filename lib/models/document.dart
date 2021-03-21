import 'package:cloud_firestore/cloud_firestore.dart';

class Document {
  DocumentSnapshot doc;
  int a1;
  DateTime a2;
  DateTime a3;
  DateTime a4;
  DateTime a5;
  String a6;
  String a7;
  bool a8;
  String a9;
  String a10;
  String a11;
  String a12;
  bool a13;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Document &&
              runtimeType == other.runtimeType &&
              doc.documentID == other.doc.documentID;

  Document(
      {this.doc,
        this.a1 = 0,
        this.a2,
        this.a3,
        this.a7,
        this.a13 = false,
        this.a4,
        this.a5});

  @override
  int get hashCode => doc.documentID.hashCode;
}