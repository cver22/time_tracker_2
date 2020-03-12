import 'package:flutter/material.dart';
import 'package:time_tracker_2/app/landing_page.dart';
import 'package:time_tracker_2/services/auth.dart';
import 'package:time_tracker_2/services/auth_provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      //by placing AuthProvider at the top of the widget tree, we allow all
      //children to access it. No longer has to be passed down each level of
      //widget tree
      auth: Auth(),
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );

    //this is a change

  }
}
