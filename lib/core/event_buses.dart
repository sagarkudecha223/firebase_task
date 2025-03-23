import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';

class UpdateHeaderBusEvent extends BusEvent {
  @override
  // ignore: hash_and_equals, avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is UpdateHeaderBusEvent;
  }
}

class SignOutBusEvent extends BusEvent {
  @override
  // ignore: hash_and_equals, avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is SignOutBusEvent;
  }
}

class AppResumedBusEvent extends BusEvent {
  @override
  // ignore: hash_and_equals, avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is AppResumedBusEvent;
  }
}

class BackButtonPressedBusEvent extends BusEvent {
  @override
  // ignore: hash_and_equals, avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is BackButtonPressedBusEvent;
  }
}

class ChangeThemeBusEvent extends BusEvent {
  @override
  // ignore: hash_and_equals, avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is ChangeThemeBusEvent;
  }
}

class OpenPDFBusEvent extends BusEvent {
  final String fileUrl;
  final String fileName;

  OpenPDFBusEvent({required this.fileUrl, required this.fileName});

  @override
  // ignore: hash_and_equals, avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is OpenPDFBusEvent;
  }
}
