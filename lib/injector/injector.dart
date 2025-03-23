import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';
import 'package:flutter_base_architecture_plugin/imports/dart_package_imports.dart';
import 'package:flutter_base_architecture_plugin/inject/base_injector.dart';

import '../bloc/login/login_bloc.dart';
import '../bloc/main_app/main_app_bloc.dart';
import '../services/firebase/firebase_service.dart';
import '../services/user/preference_store.dart';
import '../services/user/user_service.dart';

part 'injector.g.dart';

abstract class Injector extends BaseInjector {
  static late KiwiContainer container;

  static Future<bool> setup() async {
    container = BaseInjector.baseContainer;
    _$Injector()._configure();
    await container.resolve<UserService>().init();
    await container.resolve<PreferenceStore>().init();
    return true;
  }

  void _configure() {
    // Configure modules here
    _registerApis();
    _registerBloc();
  }

  @Register.singleton(PreferenceStore)
  @Register.singleton(FirebaseService)
  @Register.singleton(UserService)
  void _registerApis();

  @Register.factory(MainAppBloc)
  @Register.factory(LoginBloc)
  void _registerBloc();
}
