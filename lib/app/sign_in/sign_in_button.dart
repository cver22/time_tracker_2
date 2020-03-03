import 'package:flutter/material.dart';
import 'package:time_tracker_2/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  //class does not have properties and creates a text widget on the fly to pass
  //to the super class

  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15.0,
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}
