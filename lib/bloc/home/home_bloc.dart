import 'package:firebase_task/services/firebase/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base_architecture_plugin/extension/string_extensions.dart';
import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';

import 'home_contract.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeData> {
  HomeBloc(this._firebaseService) : super(initState) {
    on<InitHomeEvent>(_initHomeEvent);
    on<AddPostEvent>(_addPostEvent);
    on<UpdateHomeState>((event, emit) => emit(event.state));
  }

  final FirebaseService _firebaseService;

  static HomeData get initState => (HomeDataBuilder()
        ..state = ScreenState.content
        ..isPostUploading = false
        ..textController = TextEditingController()
        ..isFetchingData = false
        ..errorMessage = '')
      .build();

  void _initHomeEvent(_, __) {}

  fetchDataEvent() => _firebaseService.fetchPosts();

  void _addPostEvent(_, __) async {
    if (state.textController.text.isNotBlank) {
      add(UpdateHomeState(state.rebuild((u) => u.isPostUploading = true)));
      await _firebaseService.addPost(state.textController.text);
      add(UpdateHomeState(state.rebuild((u) => u
        ..isPostUploading = false
        ..textController?.text = '')));
    } else {
      dispatchViewEvent(DisplayMessage(
          message: 'Post should not be blank', type: DisplayMessageType.toast));
    }
  }
}
