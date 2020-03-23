import 'package:flutter/foundation.dart';
import 'package:time_tracker_2/app/sign_in/validators.dart';
import 'package:time_tracker_2/services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have and account? Sign in';
  }

  bool get submitEnabled {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get showErrorPassword {
    bool showPasswordError = submitted && !passwordValidator.isValid(password);
    return showPasswordError ? invalidPasswordErrorText : null;
  }

  String get showErrorEmail {
    bool showEmailError = submitted && !emailValidator.isValid(email);
    return showEmailError ? invalidPasswordErrorText : null;
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    //non null property will update below, otherwise, original value is kept
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    // calls all registered listeners so they know the object has changed
    notifyListeners();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);

    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      //only need to update model if sign-in fails, otherwise page dismissed
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;

    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email.trim());

  void updatePassword(String password) => updateWith(password: password);
}
