import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;

  CustomRaisedButton({
    this.child,
    this.color,
    this.borderRadius: 2.0, //assigns a default value of 2.0
    this.onPressed,
    this.height: 50.0, // default value of 50.0
  }): assert (borderRadius != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
