import 'package:time_tracker_2/app/home_page.dart';
import 'package:time_tracker_2/app/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_2/services/auth.dart';

class LandingPage extends StatefulWidget {
  LandingPage({@required this.auth});
  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  void _updateUser(User user) {
    setState(() {
      _user = user;
        });
  }

  Future<void> _checkCurrentUser() async {
  User user = await widget.auth.currentUser();
  //need to access the LandingPage widget
  //accessing the dependency in the widget
  _updateUser(user);
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        //onSignIn: (user) => _updateUser(user), deprecated
        onSignIn: _updateUser,
        auth: widget.auth,
      );
    }
    return HomePage(
      auth: widget.auth,
      onSignOut: () => _updateUser(null),
    );
  }
}
