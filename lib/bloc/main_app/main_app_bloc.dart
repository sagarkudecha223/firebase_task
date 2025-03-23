import 'dart:io';
import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';

import '../../core/event_buses.dart';
import '../../core/routes.dart';
import '../../services/user/user_service.dart';
import 'main_app_contract.dart';

class MainAppBloc extends BaseBloc<MainAppEvent, MainAppData> {
  MainAppBloc(this._eventBus, this._userService) : super(initState) {
    on<InitEvent>(_initEvent);
    on<DisposeEvent>(_disposeEvent);
    on<InActiveEvent>(_inActiveEvent);
    on<AppResumedEvent>(_appResumedEvent);
    on<UpdateMainAppState>((event, emit) => emit(event.state));
    _observeEventBus();
  }

  final UserService _userService;
  final EventBus _eventBus;

  static MainAppData get initState => (MainAppDataBuilder()
        ..state = ScreenState.loading
        ..isLoggedIn = false)
      .build();

  void _initEvent(_, __) {
    add(UpdateMainAppState(state.rebuild((u) => u
      ..isLoggedIn = _userService.isUserLoggedIn
      ..state = ScreenState.content)));
  }

  void _inActiveEvent(_, __) => printLog(message: 'App is Inactive');

  void _appResumedEvent(_, __) => _eventBus.sendEvent(AppResumedBusEvent());

  void _disposeEvent(_, __) => exit(0);

  void _observeEventBus() =>
      _eventBus.events.listen(_handleBusEvents).bindToLifecycle(this);

  void _handleBusEvents(BusEvent it) async {
    switch (it.runtimeType) {
      case const (SignOutBusEvent):
        final status = await _userService.signOut();
        if (status) {
          dispatchViewEvent(NavigateScreen(AppRoutes.loginScreen));
        }
        break;
      case const (ChangeThemeBusEvent):
        dispatchViewEvent(ChangeTheme());
        break;
    }
  }
}
