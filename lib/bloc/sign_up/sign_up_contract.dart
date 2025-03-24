import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';
import 'package:flutter_base_architecture_plugin/imports/dart_package_imports.dart';
import 'package:flutter/material.dart' as material;

part 'sign_up_contract.g.dart';

abstract class SignUpData implements Built<SignUpData, SignUpDataBuilder> {
  factory SignUpData([void Function(SignUpDataBuilder) updates]) = _$SignUpData;

  SignUpData._();

  ScreenState get state;

  material.TextEditingController get usernameController;

  material.TextEditingController get passwordController;

  bool? get isLoginButtonLoading;

  String? get errorMessage;
}

abstract class SignUpEvent {}

class InitSignUpEvent extends SignUpEvent {}

class SignUpTapEvent extends SignUpEvent {}

class UpdateSignUpState extends SignUpEvent {
  final SignUpData state;

  UpdateSignUpState(this.state);
}
