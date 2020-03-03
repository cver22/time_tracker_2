import 'package:flutter/material.dart';
import 'package:time_tracker_2/app/landing_page.dart';
import 'package:time_tracker_2/services/auth.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: LandingPage(
auth: Auth(),
      ),
    );

    //this is a change

  }
}
