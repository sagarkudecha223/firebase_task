import 'package:firebase_task/core/app_extension.dart';
import 'package:firebase_task/ui/common/app_loader.dart';
import 'package:firebase_task/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';
import 'package:flutter_base_architecture_plugin/imports/dart_package_imports.dart';
import 'package:flutter_base_architecture_plugin/imports/extension_imports.dart';
import 'package:gap/gap.dart';

import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_contract.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/dimens.dart';
import '../../core/enum.dart';
import '../../core/routes.dart';
import '../common/app_text_field.dart';
import '../common/app_toast.dart';
import '../common/elevated_button.dart';
import '../common/text_button.dart';
import '../sign_up/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginBloc, LoginScreen> {
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
      case AppRoutes.homeScreen:
        navigatorKey.currentContext?.pushAndRemoveUntil(
          settings: RouteSettings(name: screen.target),
          builder: (_) => const HomeScreen(),
        );
        break;
      case AppRoutes.signUpScreen:
        navigatorKey.currentContext?.push(
          settings: RouteSettings(name: screen.target),
          builder: (_) => const SignUpScreen(),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
            child: BlocProvider<LoginBloc>(
                create: (_) => bloc,
                child: BlocBuilder<LoginBloc, LoginData>(
                    builder: (_, __) => _MainContent(bloc: bloc)))));
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.content:
        return _LoginContent(bloc: bloc);
      default:
        return const AppLoader();
    }
  }
}

class _LoginContent extends StatelessWidget {
  final LoginBloc bloc;

  const _LoginContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LoginTextFieldView(bloc: bloc),
          const Gap(Dimens.space4xSmall),
          _LoginButton(
            isLoading: bloc.state.isLoginButtonLoading ?? false,
            onTap: () => bloc.add(LoginButtonTapEvent()),
          ),
          const Gap(Dimens.spaceMedium),
          _CreateAccountButton(onTap: () => bloc.add(CreteAccountTapEvent()))
        ],
      ),
    );
  }
}

class _LoginTextFieldView extends StatelessWidget {
  final LoginBloc bloc;

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
            .toList());
  }
}

class _CommonTextField extends StatelessWidget {
  final LoginTextFieldEnum loginTextFieldEnum;
  final bool isPasswordText;
  final LoginBloc bloc;

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
          textEditingController:
              bloc.getTextController(loginTextFieldEnum: loginTextFieldEnum),
          onSubmitted: (_) =>
              isPasswordText ? bloc.add(LoginButtonTapEvent()) : null,
          textInputAction:
              !isPasswordText ? TextInputAction.next : TextInputAction.done,
          onTapOutside: () => navigatorKey.currentContext?.hideKeyboard(),
          suffixIconType:
              isPasswordText ? TextFieldSuffixIconType.showObscureText : null,
          obscureText: isPasswordText),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final Function() onTap;

  const _LoginButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      title: 'Login',
      onTap: onTap,
      isLoading: isLoading,
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  final Function() onTap;

  const _CreateAccountButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      title: 'Sign up',
      hasBorder: true,
      textColor: AppColors.primaryBlue1,
      onTap: onTap,
    );
  }
}
