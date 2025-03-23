import 'package:firebase_task/core/app_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/enum.dart';

class PreferenceStore {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  List<SharedPreferenceStore> nonResetValueList = [];

  Future<void> reset() async {
    for (int index = 0; index < SharedPreferenceStore.values.length; index++) {
      if (!nonResetValueList.contains(SharedPreferenceStore.values[index])) {
        await _sharedPreferences
            .remove(SharedPreferenceStore.values[index].preferenceKey);
      }
    }
  }

  Future<bool> setValue(
      {required SharedPreferenceStore value, required dynamic data}) async {
    switch (value.getRuntimeType) {
      case const (bool):
        return await _sharedPreferences.setBool(
            value.preferenceKey, data as bool);
      case const (String):
        return await _sharedPreferences.setString(
            value.preferenceKey, data as String);
    }
    return false;
  }

  dynamic getValue({required SharedPreferenceStore value}) {
    switch (value.getRuntimeType) {
      case const (bool):
        return _sharedPreferences.getBool(value.preferenceKey) ?? false;
      case const (String):
        return _sharedPreferences.getString(value.preferenceKey) ?? '';
    }
  }
}
