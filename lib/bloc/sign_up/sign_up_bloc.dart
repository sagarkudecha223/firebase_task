import 'package:firebase_task/services/firebase/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';

import '../../core/enum.dart';
import '../../core/routes.dart';
import 'sign_up_contract.dart';

class SignUpBloc extends BaseBloc<SignUpEvent, SignUpData> {
  SignUpBloc(this._firebaseService) : super(initState) {
    on<InitSignUpEvent>(_initSignUpEvent);
    on<SignUpTapEvent>(_signUpTapEvent);
    on<UpdateSignUpState>((event, emit) => emit(event.state));
  }

  final FirebaseService _firebaseService;

  static SignUpData get initState => (SignUpDataBuilder()
        ..state = ScreenState.content
        ..passwordController = TextEditingController()
        ..usernameController = TextEditingController()
        ..errorMessage = '')
      .build();

  TextEditingController? getTextController(
      {required LoginTextFieldEnum loginTextFieldEnum}) {
    switch (loginTextFieldEnum) {
      case LoginTextFieldEnum.username:
        return state.usernameController;
      case LoginTextFieldEnum.password:
        return state.passwordController;
    }
  }

  void _initSignUpEvent(_, __) {}

  void _signUpTapEvent(_, __) async {
    if (_isValidData()) {
      _updateLoginButtonState(true);
      final user = await _firebaseService.signUp(
          state.usernameController.text, state.usernameController.text);
      if (user != null) {
        dispatchViewEvent(NavigateScreen(AppRoutes.loginScreen));
      } else {
        _dispatchMessage('Something went Wrong!');
      }
      _updateLoginButtonState(false);
    }
  }

  void _updateLoginButtonState(bool status) => add((UpdateSignUpState(
      state.rebuild((u) => u.isLoginButtonLoading = status))));

  bool _isValidData() {
    if (state.usernameController.text.isEmpty) {
      _dispatchMessage('Enter Email Address');
      return false;
    } else if (!isValidEmail(state.usernameController.text)) {
      _dispatchMessage('Enter valid Email Address');
      return false;
    } else if (state.passwordController.text.isEmpty) {
      _dispatchMessage('Enter Password');
      return false;
    }
    return true;
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _dispatchMessage(String message) => dispatchViewEvent(
      DisplayMessage(message: message, type: DisplayMessageType.toast));
}
