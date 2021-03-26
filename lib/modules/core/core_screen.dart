import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/config/styles/default_button_style.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/util/components/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bloc/core_bloc.dart';

class CoreScreen extends StatefulWidget {
  const CoreScreen({
    @required RouteObserver routeObserver,
    @required AccountRepository accountRepository,
  })  : _routeObserver = routeObserver,
        _accountRepository = accountRepository;

  final RouteObserver _routeObserver;
  final AccountRepository _accountRepository;

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
        CoreBloc tempBloc = CoreBloc(widget._accountRepository);
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocConsumer<CoreBloc, CoreState>(
        listener: (BuildContext context, CoreState state) {
          if (state.nextRoute != null) {
            if (state.nextRoute == AppRoutes.appRestart) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamedAndRemoveUntil(state.nextRoute, (route) {
                return false;
              });
            } else {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(state.nextRoute);
            }
          }
          // } else if (state is Logout) {
          //   Navigator.pop(context);
          // }
        },
        builder: (BuildContext context, CoreState state) {
          return Container(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Scaffold(
                body: _getBody(context, state),
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

  Widget _getBody(BuildContext context, CoreState state) {
    Widget body = Container();
    if (state is Home) {
      return Container(
        color: BoilerColors.orange,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/logo.svg',
                  width: 72, height: 72, color: Colors.green),
              Text(
                state.user?.username ?? "",
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                state.user?.email ?? "",
                style: Theme.of(context).textTheme.headline1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CoreBloc>().add(Logout());
                  },
                  style: getDefaultButtonStyle(),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (state is History) {
      return Container(
        color: BoilerColors.white[40],
      );
    } else if (state is Profile) {
      return Container(
        color: BoilerColors.white[24],
      );
    }
    return body;
  }
}
