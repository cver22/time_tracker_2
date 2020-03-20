import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_2/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_2/common_widgets/form_submit_button.dart';
import 'package:time_tracker_2/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_2/services/auth.dart';
import 'package:flutter/services.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({@required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    //passes the auth to the emailSignInBloc
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBased createState() => _EmailSignInFormBlocBased();
}

class _EmailSignInFormBlocBased extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
      await widget.bloc.submit();
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

  void _emailEditingComplete(EmailSignInModel model) {
    //keeps focus on email field if invalid email is entered
    //otherwise passes to password field
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailEditingController.clear();
    _passwordEditingController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8.0),
      _buildPasswordTextField(model),
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

  TextField _buildPasswordTextField(EmailSignInModel model) {
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
      onChanged: widget.bloc.updatePassword,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
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
      onEditingComplete: () => _emailEditingComplete(model),
      //automatically passes the email to the callback
      onChanged: widget.bloc.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    //gets passed the context and builds the page
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          //extracts emailSIgnInModel from the stream builder to be passed to components that need it
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
