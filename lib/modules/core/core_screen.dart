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
    required RouteObserver routeObserver,
    required AccountRepository accountRepository,
  })  : _routeObserver = routeObserver,
        _accountRepository = accountRepository;

  final RouteObserver _routeObserver;
  final AccountRepository _accountRepository;

  @override
  _CoreScreenState createState() => _CoreScreenState();
}

class _CoreScreenState extends State<CoreScreen> with RouteAware {
  CoreBloc? bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      widget._routeObserver.subscribe(this, route);
    }
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
          String? localNextRoute = state.nextRoute;

          if (localNextRoute != null) {
            if (localNextRoute == AppRoutes.appRestart) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamedAndRemoveUntil(localNextRoute, (route) {
                return false;
              });
            } else {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(localNextRoute);
            }
          }
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
    if (state is Home) {
      return Container(
        color: RideColors.orange,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/logo.svg',
                  width: 72, height: 72, color: Colors.green),
              Text(
                state.user?.name ?? "",
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                state.user?.idUFSC ?? "",
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
        color: RideColors.white[40],
      );
    } else if (state is Profile) {
      return Container(
        color: RideColors.white[24],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }
}
