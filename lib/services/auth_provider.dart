import 'package:flutter/material.dart';

import 'auth.dart';

class AuthProvider extends InheritedWidget{
  AuthProvider({@required this.auth,@required this.child});
  final AuthBase auth;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget)  => false;

  //final auth = AuthProvider.of(context);
  //static method is a class wide method, not specific to each instance
  static AuthBase of(BuildContext context){
    AuthProvider provider = context.dependOnInheritedWidgetOfExactType();
    return provider.auth;
  }

}