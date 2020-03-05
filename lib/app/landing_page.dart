import 'package:time_tracker_2/app/home_page.dart';
import 'package:time_tracker_2/app/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_2/services/auth.dart';

class LandingPage extends StatelessWidget {
  //was a stateful widget before adding streambuilder
  //keeps the app signed in even when not in use or closed
  LandingPage({@required this.auth});

  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      //type safety of User
      //removes the need for the landing page to be a stateful widget
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: auth,
            );
          }
          return HomePage(
            auth: auth,
          );
        } else {
          // if the app is still trying to determine if someone is logging in the indicator shows
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
