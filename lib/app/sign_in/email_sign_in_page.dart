import 'package:flutter/material.dart';
import 'package:time_tracker_2/app/sign_in/email_sign_in_form_bloc_based.dart';
import 'package:time_tracker_2/app/sign_in/email_sign_in_form_change_notifier.dart';


class EmailSignInPage extends StatelessWidget {

   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
    );
  }
}
