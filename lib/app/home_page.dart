import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_2/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.auth});

  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      auth.signOut();
    } catch (e) {
      print(e);
      //TODO - Show Alert
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }
}
