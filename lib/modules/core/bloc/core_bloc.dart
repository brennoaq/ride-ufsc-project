import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:equatable/equatable.dart';

part 'core_event.dart';

part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  CoreBloc(AccountRepository accountRepository)
      : _accountRepository = accountRepository,
        super(InitialState()) {
    listeners.add(_accountRepository.userModelStream.listen((user) {
      if (user != null) {
        userModel = user;
        add(UserUpdated(user));
      }
    }));
    listeners.add(_accountRepository.tokenStream.listen((token) {
      if (token != null) {
        add(TokenUpdated(token));
      }
    }));
  }

  List<StreamSubscription> listeners = [];
  final AccountRepository _accountRepository;
  UserModel? userModel;
  int tabIndex = 0;

  @override
  Stream<CoreState> mapEventToState(
    CoreEvent event,
  ) async* {
    yield _mapEventToState(event);
  }

  CoreState _mapEventToState(CoreEvent event) {
    if (event is OnTabChanged) {
      return _mapOnChangedTabEvent(event);
    } else if (event is Logout) {
      return _mapLogoutEventToState();
    } else if (event is ScreenResumed) {
      return _mapScreenResumedEventToState();
    } else if (event is UserUpdated) {
      return _getTabState(null);
    } else if (event is TokenUpdated) {
      return _mapOnTokenUpdatedEvent(event);
    }
    return state;
  }

  CoreState _mapOnChangedTabEvent(OnTabChanged event) {
    tabIndex = event.tabIndex;
    return _getTabState(null);
  }

  CoreState _mapOnTokenUpdatedEvent(TokenUpdated event) {
    if (event.token == null) return _getTabState(AppRoutes.appRestart);
    return state;
  }

  CoreState _mapScreenResumedEventToState() {
    CoreState currentState = state;
    if (currentState is Home) {
      return Home(userModel, null);
    } else if (currentState is Profile) {
      return Profile(userModel, null);
    } else if (currentState is History) {
      return History(userModel, null);
    }
    return currentState;
  }

  CoreState _mapLogoutEventToState() {
    _accountRepository.logout();
    return state;
  }

  CoreState _getTabState(String? nextRoute) {
    switch (tabIndex) {
      case 1:
        return History(userModel, nextRoute);
      case 2:
        return Profile(userModel, nextRoute);
      default:
        return Home(userModel, nextRoute);
    }
  }

  @override
  Future<void> close() {
    listeners.forEach((element) {
      element.cancel();
    });
    return super.close();
  }
}
