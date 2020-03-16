import 'dart:async';

class SignInBloc{
  final StreamController<bool> _isloadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isloadingController.stream;

  void dispose() {
    _isloadingController.close();
  }

  void setIsLoading(bool isLoading) => _isloadingController.add(isLoading);
}