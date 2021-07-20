import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/config/styles/default_button_style.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate_flutter/modules/register/bloc/register_bloc.dart';
import 'package:boilerplate_flutter/modules/register/components/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    required RouteObserver routeObserver,
    required AccountRepository accountRepository,
  })  : _routeObserver = routeObserver,
        _accountRepository = accountRepository;

  final RouteObserver _routeObserver;
  final AccountRepository _accountRepository;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with RouteAware {
  RegisterBloc? bloc;
  final _formKey = GlobalKey<FormState>();

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
    bloc?.add(OnScreenResumed());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (BuildContext context) {
        RegisterBloc tempBloc = RegisterBloc(widget._accountRepository);
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (BuildContext context, RegisterState state) {
          if (state is IdleRegister) {
            String? localNextRoute = state.nextRoute;
            if (localNextRoute != null && localNextRoute == AppRoutes.login) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamedAndRemoveUntil(localNextRoute, (route) {
                return false;
              });
            } else if (localNextRoute != null) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(localNextRoute);
            }
          }
        },
        builder: (BuildContext context, RegisterState state) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  'Cadastro',
                  style: TextStyle(
                    fontFamily: 'Courier Prime',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 2,
                    color: Colors.lightBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                leading: BackButton(
                  color: Colors.lightBlue,
                ),
                centerTitle: true,
              ),
              body: _getBody(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(BuildContext context, RegisterState state) {
    if (state is IdleRegister) {
      return SingleChildScrollView(
        child: RegisterForm(state, _formKey),
      );
    } else if (state is Error) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Text(state.error.toString()),
            ElevatedButton(
              onPressed: () {
                context.read<RegisterBloc>().add(OnFormChanged());
              },
              style: getDefaultButtonStyle(),
              child: Text(
                'Ok',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
