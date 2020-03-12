import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_2/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_2/services/auth.dart';
import 'package:time_tracker_2/services/auth_provider.dart';

class HomePage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = AuthProvider.of(context);
      await auth.signOut();
    } catch (e) {
      print(e);
      //TODO - Show Alert
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure you want to log out?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',

    ).show(context);

    if(didRequestSignOut){
      _signOut(context);
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
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
