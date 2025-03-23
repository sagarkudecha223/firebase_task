import 'dart:async';

import '../../core/enum.dart';
import 'preference_store.dart';

class UserService {
  UserService(this._preferenceStore);

  final PreferenceStore _preferenceStore;

  FutureOr<void> init() async {}

  FutureOr<bool> signOut() async {
    _preferenceStore.reset();
    return true;
  }

  Future<bool> setUserLoginStatus({required bool isLoggedIn}) async =>
      await _preferenceStore.setValue(
          value: SharedPreferenceStore.IS_USER_LOGGED_IN, data: isLoggedIn);

  bool get isUserLoggedIn =>
      _preferenceStore.getValue(value: SharedPreferenceStore.IS_USER_LOGGED_IN);

}
