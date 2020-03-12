import 'package:flutter/material.dart';
import 'package:time_tracker_2/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_2/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_2/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_2/services/auth_provider.dart';

class SignInPage extends StatelessWidget {


  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = AuthProvider.of(context);
      await auth.signInAnonymously();
    } catch (e) {
      print(e);
      //TODO - Show Alert
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = AuthProvider.of(context);
      await auth.signInWithGoogle();
    } catch (e) {
      print(e);
      //TODO - Show Alert
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        //only changes how screen gets added to stack on iOS, bottom vs side
        fullscreenDialog: true,
        //navigates to email sign in page
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            textColor: Colors.black87,
            text: 'Sign in with Google',
            color: Colors.white,
            onPressed: () => _signInWithGoogle(context),
            assetName: 'images/google-logo.png',
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            textColor: Colors.white,
            text: 'Sign in with Facebook',
            color: Color(0xFF334D92),
            onPressed: () {},
            assetName: 'images/facebook-logo.png',
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anomoymus',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }
}
