import 'package:flutter/material.dart';
import 'package:time_tracker_2/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_2/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_2/services/auth.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.auth});

  final AuthBase auth;

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e);
      //TODO - Show Alert
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e);
      //TODO - Show Alert
    }
  }

  void _signInWithEmail(BuildContext context){
    // TODO: sign in page

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
            onPressed: _signInWithGoogle,
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
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
