import 'package:flutter/material.dart';

class ModalProgressIndicator extends StatelessWidget {
  const ModalProgressIndicator({
    Key key,
    @required bool isLoading,
    @required Widget child,
  })  : _isLoading = isLoading,
        _child = child,
        super(key: key);

  final bool _isLoading;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return !_isLoading
        ? _child
        : Stack(children: [
            _child,
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(
                dismissible: false,
                color: Colors.grey,
              ),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ]);
  }
}
