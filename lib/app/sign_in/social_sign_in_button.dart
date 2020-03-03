import 'package:flutter/material.dart';
import 'package:time_tracker_2/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  //class does not have properties and creates a text widget on the fly to pass
  //to the super class

  SocialSignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
    @required String assetName,
  })  : assert(text != null),
        assert(assetName != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15.0,
                ),
              ),
              Opacity(
                child: Image.asset(assetName),
                opacity: 0.0,
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
