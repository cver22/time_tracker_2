import 'package:flutter/material.dart';

class EmailSignInPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 2.0,
      ),
      body: _buildContent(),
    );
  }

  _buildContent() {
    return Container();
  }
}
