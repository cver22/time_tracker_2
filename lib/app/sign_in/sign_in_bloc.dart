import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker_2/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      //moved set loading state so only matters if an error is called, otherwise
      //the widget tree gets rebuilt anyway and with set loading set to false
      //prevents adding to a closed stream
      _setIsLoading(false);
      rethrow;
    }
  }

//Passes the function to the method for the method to call the function

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}
