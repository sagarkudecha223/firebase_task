import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';
import 'package:flutter_base_architecture_plugin/imports/dart_package_imports.dart';

part 'home_contract.g.dart';

abstract class HomeData implements Built<HomeData, HomeDataBuilder> {
  factory HomeData([void Function(HomeDataBuilder) updates]) = _$HomeData;

  HomeData._();

  ScreenState get state;

  User? get currentUser;

  Stream<List<Map<String, dynamic>>>? get postList;

  bool get isPostUploading;

  material.TextEditingController get textController;

  bool get isFetchingData;

  String? get errorMessage;
}

abstract class HomeEvent {}

class InitHomeEvent extends HomeEvent {}

class AddPostEvent extends HomeEvent {}

class UpdateHomeState extends HomeEvent {
  final HomeData state;

  UpdateHomeState(this.state);
}
