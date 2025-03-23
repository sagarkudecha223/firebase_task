import 'package:firebase_task/services/user/user_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';

import '../../core/enum.dart';
import '../../core/routes.dart';
import '../../services/firebase/firebase_service.dart';
import 'login_contract.dart';

class LoginBloc extends BaseBloc<LoginEvent, LoginData> {
  LoginBloc(this._firebaseService, this._userService) : super(initState) {
    on<InitLoginEvent>(_initLoginEvent);
    on<CreteAccountTapEvent>(_creteAccountTapEvent);
    on<LoginButtonTapEvent>(_loginButtonTapEvent);
    on<UpdateLoginState>((event, emit) => emit(event.state));
  }

  final FirebaseService _firebaseService;
  final UserService _userService;

  static LoginData get initState => (LoginDataBuilder()
        ..state = ScreenState.content
        ..passwordController = TextEditingController()
        ..usernameController = TextEditingController()
        ..errorMessage = '')
      .build();

  void _initLoginEvent(_, __) {}

  TextEditingController? getTextController(
      {required LoginTextFieldEnum loginTextFieldEnum}) {
    switch (loginTextFieldEnum) {
      case LoginTextFieldEnum.username:
        return state.usernameController;
      case LoginTextFieldEnum.password:
        return state.passwordController;
    }
  }

  void _updateLoginButtonState(bool status) => add((UpdateLoginState(
      state.rebuild((u) => u.isLoginButtonLoading = status))));

  void _loginButtonTapEvent(_, __) async {
    if (_isValidData()) {
      _updateLoginButtonState(true);
      if (await _haveAccount()) {
        _userService.setUserLoginStatus(isLoggedIn: true);
        dispatchViewEvent(NavigateScreen(AppRoutes.homeScreen));
      } else {
        _dispatchMessage('Invalid Credentials');
      }
      _updateLoginButtonState(false);
    }
  }

  bool _isValidData() {
    if (state.usernameController.text.isEmpty) {
      _dispatchMessage('Enter Email Address');
      return false;
    } else if (state.passwordController.text.isEmpty) {
      _dispatchMessage('Enter Password');
      return false;
    }
    return true;
  }

  Future<bool> _haveAccount() async {
    final user = await _firebaseService.login(
        state.usernameController.text, state.usernameController.text);
    return user != null ? true : false;
  }

  void _creteAccountTapEvent(_, __) =>
      dispatchViewEvent(NavigateScreen(AppRoutes.signUpScreen));

  void _dispatchMessage(String message) => dispatchViewEvent(
      DisplayMessage(message: message, type: DisplayMessageType.toast));
}
