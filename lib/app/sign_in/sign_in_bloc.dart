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
      //use the () to call the method
      return await signInMethod();
    } catch (e) {
      //passes error back to call
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  Future<User> signInAnonymously() async {
    //passing without the () only passes the method, does not call it
    return await _signIn(auth.signInAnonymously);
  }

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}
