import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  User({@required this.uid});

  final String uid;
}

abstract class AuthBase {
  Future<User> currentUser();

  Future<User> signInAnonymously();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
    // returns only the string
    //decouples the app from the authentication
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}
