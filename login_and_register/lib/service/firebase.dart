import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class firebaseService {
  Future<dynamic> checkUser(
          {required TextEditingController email,
          required TextEditingController password}) async =>
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text.trim(),
              // email: 'achmaddp26@gmail.com',
              // password: "12345678asd");
              password: password.text.trim())
          .then((value) async {
        if (value.user?.uid != null) {
          final ref = FirebaseDatabase.instance.ref();
          final snapshot = await ref.child('users/${value.user?.uid}').get();
          return snapshot.value;
        }
        return [];
        // print(value.user?.uid);
      });
  Future<dynamic> register(
      {required TextEditingController email,
      required TextEditingController password,
      required TextEditingController phoneNumber,
      required TextEditingController fullName,
      required TextEditingController username}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((value) async {
        if (value.user?.uid != null) {
          DatabaseReference ref =
              FirebaseDatabase.instance.ref("users/${value.user?.uid}");
          await ref.set({
            "name": fullName.text,
            "username": username.text,
            "phoneNumber": phoneNumber.text,
            "email": email.text
          });
          //simpen ke db
          return true;
        } else {
          return false;
        }

        // print(value.user?.uid);
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
    return false;
  }

  Future<dynamic> getData(String uid) async {
    Map data = {};
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/$uid').get();
    if (snapshot.exists) {
      // print(snapshot.value);
      return snapshot.value;
    } else {
      print('No data available.');
    }
    return [];
  }
}
