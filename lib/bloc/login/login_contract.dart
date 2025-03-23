import 'package:flutter/material.dart' as material;
import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';
import 'package:flutter_base_architecture_plugin/imports/dart_package_imports.dart';

part 'login_contract.g.dart';

abstract class LoginData implements Built<LoginData, LoginDataBuilder> {
  factory LoginData([void Function(LoginDataBuilder) updates]) = _$LoginData;

  LoginData._();

  ScreenState get state;

  material.TextEditingController get usernameController;

  material.TextEditingController get passwordController;

  bool? get isLoginButtonLoading;

  String? get errorMessage;
}

abstract class LoginEvent {}

class InitLoginEvent extends LoginEvent {}

class LoginButtonTapEvent extends LoginEvent {}

class CreteAccountTapEvent extends LoginEvent {}

class UpdateLoginState extends LoginEvent {
  final LoginData state;

  UpdateLoginState(this.state);
}
