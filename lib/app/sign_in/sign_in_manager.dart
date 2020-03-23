import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker_2/services/auth.dart';

class SignInManager {
  //change name from signInBloc as it no longer uses streams
  SignInManager({@required this.auth, @required this.isLoading});

  //using ValueNotifier to replace stream controller
  final ValueNotifier<bool> isLoading;
  final AuthBase auth;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      //moved set loading state so only matters if an error is called, otherwise
      //the widget tree gets rebuilt anyway and with set loading set to false
      //prevents adding to a closed stream
      isLoading.value = false;
      rethrow;
    }
  }

//Passes the function to the method for the method to call the function

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}
