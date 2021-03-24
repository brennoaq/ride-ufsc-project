part of 'core_bloc.dart';

abstract class CoreEvent extends Equatable {
  const CoreEvent();

  @override
  List<Object> get props => [];
}

class OnTabChanged extends CoreEvent {
  const OnTabChanged(this.tabIndex) : super();

  final int tabIndex;

  @override
  List<Object> get props => [tabIndex];
}

class ScreenResumed extends CoreEvent {
  ScreenResumed();
}

class Logout extends CoreEvent {
  Logout();
}

class CoreScreenUpdated extends CoreEvent {
  CoreScreenUpdated();

  @override
  List<Object> get props => [];
}
