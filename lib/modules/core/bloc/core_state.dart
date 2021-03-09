part of 'core_bloc.dart';

abstract class CoreState extends Equatable {
  const CoreState(this.index, this.nextRoute);

  final index;
  final String nextRoute;

  @override
  List<Object> get props => [index, nextRoute];
}

class Home extends CoreState {
  const Home(String nextRoute) : super(0, nextRoute);
}

class History extends CoreState {
  const History(String nextRoute) : super(1, nextRoute);
}

class Profile extends CoreState {
  const Profile(String nextRoute) : super(2, nextRoute);
}

class InitialState extends CoreState {
  InitialState() : super(0, null);
}
