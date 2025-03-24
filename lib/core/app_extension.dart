import 'enum.dart';
import 'images.dart';

extension ImageIcon on TextFieldSuffixIconType {
  static String _imageIcon(TextFieldSuffixIconType val) {
    switch (val) {
      case TextFieldSuffixIconType.cancel:
        return Images.cancel;
      case TextFieldSuffixIconType.showObscureText:
        return Images.showObscureText;
      case TextFieldSuffixIconType.hideObscureText:
        return Images.hideObscureText;
    }
  }

  String get imageIcon => _imageIcon(this);
}

extension SharedPreferenceStoreExtractor on SharedPreferenceStore {
  String get preferenceKey => name;

  Type get getRuntimeType {
    switch (this) {
      case SharedPreferenceStore.IS_USER_LOGGED_IN:
        return bool;
      case SharedPreferenceStore.USER_DETAILS:
        return String;
    }
  }
}

extension LoginTextFieldEnumExtention on LoginTextFieldEnum {
  String get title {
    switch (this) {
      case LoginTextFieldEnum.username:
        return 'Email';
      case LoginTextFieldEnum.password:
        return 'Password';
    }
  }
}
