import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part 'core_event.dart';

part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  CoreBloc() : super(InitialState()) {
    add(OnTabChanged(0));
  }

  List<StreamSubscription> listeners = [];

  @override
  Stream<CoreState> mapEventToState(
    CoreEvent event,
  ) async* {
    yield _mapEventToState(event);
  }

  CoreState _mapEventToState(CoreEvent event) {
    if (event is OnTabChanged) {
      return _mapOnChangedTabEvent(event);
    } else if (event is ScreenResumed) {
      return _mapScreenResumedEventToState();
    }
    return state;
  }

  CoreState _mapOnChangedTabEvent(OnTabChanged event) {
    switch (event.tabIndex) {
      case 1:
        return History(null);
      case 2:
        return Profile(null);
      default:
        return Home(null);
    }
  }

  CoreState _mapScreenResumedEventToState() {
    CoreState currentState = state;
    if (currentState is Home) {
      return Home(null);
    } else if (currentState is Profile) {
      return Profile(null);
    } else if (currentState is History) {
      return History(null);
    }
    return currentState;
  }

  @override
  Future<void> close() {
    listeners.forEach((element) {
      element.cancel();
    });
    return super.close();
  }
}
