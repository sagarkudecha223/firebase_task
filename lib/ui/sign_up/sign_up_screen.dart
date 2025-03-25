import 'package:firebase_task/core/app_extension.dart';
import 'package:firebase_task/ui/common/app_loader.dart';
import 'package:firebase_task/ui/common/common_app_bar.dart';
import 'package:firebase_task/ui/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';
import 'package:flutter_base_architecture_plugin/imports/dart_package_imports.dart';
import 'package:flutter_base_architecture_plugin/imports/extension_imports.dart';
import 'package:gap/gap.dart';

import '../../bloc/sign_up/sign_up_bloc.dart';
import '../../bloc/sign_up/sign_up_contract.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/dimens.dart';
import '../../core/enum.dart';
import '../../core/routes.dart';
import '../common/app_text_field.dart';
import '../common/app_toast.dart';
import '../common/elevated_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseState<SignUpBloc, SignUpScreen> {
  @override
  void onViewEvent(ViewAction event) {
    switch (event.runtimeType) {
      case const (DisplayMessage):
        buildHandleMessage(event as DisplayMessage);
        break;
      case const (NavigateScreen):
        buildHandleActionEvent(event as NavigateScreen);
        break;
    }
  }

  void buildHandleMessage(DisplayMessage displayMessage) {
    final message = displayMessage.message;
    final type = displayMessage.type;
    switch (type) {
      case DisplayMessageType.toast:
        context.showToast(AppToast(message: message!));
        break;
      default:
        break;
    }
  }

  void buildHandleActionEvent(NavigateScreen screen) async {
    switch (screen.target) {
      case AppRoutes.loginScreen:
        navigatorKey.currentContext?.pushAndRemoveUntil(
          settings: RouteSettings(name: screen.target),
          builder: (_) => const LoginScreen(),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CommonAppBar(title: 'Sign Up'),
        body: SafeArea(
            child: BlocProvider<SignUpBloc>(
                create: (_) => bloc,
                child: BlocBuilder<SignUpBloc, SignUpData>(
                    builder: (_, __) => _MainContent(bloc: bloc)))));
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final SignUpBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.content:
        return _SignContent(bloc: bloc);
      default:
        return const AppLoader();
    }
  }
}

class _SignContent extends StatelessWidget {
  final SignUpBloc bloc;

  const _SignContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LoginTextFieldView(bloc: bloc),
          const Gap(Dimens.space4xSmall),
          _SignUpButton(
            isLoading: bloc.state.isLoginButtonLoading ?? false,
            onTap: () => bloc.add(SignUpTapEvent()),
          ),
        ],
      ),
    );
  }
}

class _LoginTextFieldView extends StatelessWidget {
  final SignUpBloc bloc;

  const _LoginTextFieldView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: LoginTextFieldEnum.values
          .map((element) => _CommonTextField(
                loginTextFieldEnum: element,
                bloc: bloc,
                isPasswordText: element == LoginTextFieldEnum.password,
              ))
          .toList(),
    );
  }
}

class _CommonTextField extends StatelessWidget {
  final LoginTextFieldEnum loginTextFieldEnum;
  final bool isPasswordText;
  final SignUpBloc bloc;

  const _CommonTextField(
      {required this.loginTextFieldEnum,
      required this.bloc,
      required this.isPasswordText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.space2xSmall),
      child: AppTextField(
          labelText: loginTextFieldEnum.title,
          onSubmitted: (_) =>
              isPasswordText ? bloc.add(SignUpTapEvent()) : null,
          textEditingController:
              bloc.getTextController(loginTextFieldEnum: loginTextFieldEnum),
          textInputAction:
              !isPasswordText ? TextInputAction.next : TextInputAction.done,
          onTapOutside: () => navigatorKey.currentContext?.hideKeyboard(),
          suffixIconType:
              isPasswordText ? TextFieldSuffixIconType.showObscureText : null,
          obscureText: isPasswordText),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final Function() onTap;
  final bool isLoading;

  const _SignUpButton({required this.onTap, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      title: 'Sign Up',
      onTap: onTap,
      isLoading: isLoading,
    );
  }
}
