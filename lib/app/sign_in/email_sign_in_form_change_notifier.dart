import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_2/common_widgets/form_submit_button.dart';
import 'package:time_tracker_2/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_2/services/auth.dart';
import 'package:flutter/services.dart';
import 'email_sign_in_change_model.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({@required this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    //passes the auth to the emailSignInBloc
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      //creates a model class based on change notifier provider
      create: (context) => EmailSignInChangeModel(auth: auth),
      //consumer is called every time we notify the listeners in the model
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormBlocBased createState() => _EmailSignInFormBlocBased();
}

class _EmailSignInFormBlocBased extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //less typing to be able to access the widget model
  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    //removes these from operation to take them out of memory
    _emailFocusNode.dispose();
    _emailEditingController.dispose();
    _passwordFocusNode.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  //We don't need to pass context in a stateful widget as we always have access to it
  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      if (Platform.isIOS) {
        print('sow iOS dialog');
      } else {
        PlatformExceptionAlertDialog(
          title: 'Sign in failed',
          exception: e,
        ).show(context);
        //DONE show error to user
      }
    }
  }

  void _emailEditingComplete() {
    //keeps focus on email field if invalid email is entered
    //otherwise passes to password field
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailEditingController.clear();
    _passwordEditingController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordEditingController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.showErrorPassword,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      //automatically passes the password to the callback
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailEditingController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'email@company.com',
        errorText: model.showErrorEmail,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(),
      //automatically passes the email to the callback
      onChanged: model.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
