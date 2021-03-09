import 'package:builerplate_flutter/util/components/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/core_bloc.dart';

class CoreScreen extends StatefulWidget {
  const CoreScreen({@required RouteObserver routeObserver})
      : _routeObserver = routeObserver;

  final RouteObserver _routeObserver;

  @override
  _CoreScreenState createState() => _CoreScreenState();
}

class _CoreScreenState extends State<CoreScreen> with RouteAware {
  CoreBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget._routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    widget._routeObserver.unsubscribe(this);
    bloc = null;
    super.dispose();
  }

  @override
  void didPopNext() {
    bloc?.add(ScreenResumed());
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoreBloc>(
      create: (BuildContext context) {
        CoreBloc tempBloc = CoreBloc();
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocConsumer<CoreBloc, CoreState>(
        listener: (BuildContext context, CoreState state) {
          if (state.nextRoute != null) {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(state.nextRoute);
          }
        },
        builder: (BuildContext context, CoreState state) {
          return Container(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Scaffold(
                body: _getBody(state),
                bottomNavigationBar: NavigationBar(
                  currentIndex: state.index,
                  onTap: (index) {
                    context.read<CoreBloc>().add(OnTabChanged(index));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(CoreState state) {
    Widget body = Container();
    if (state is Home) {
      return Container();
    } else if (state is History) {
      return Container();
    } else if (state is Profile) {
      return Container();
    }
    return body;
  }
}
