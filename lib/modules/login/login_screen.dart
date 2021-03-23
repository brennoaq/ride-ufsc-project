import 'package:boilerplate_flutter/modules/login/bloc/login_bloc.dart';
import 'package:boilerplate_flutter/modules/login/components/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) {
        LoginBloc tempBloc = LoginBloc();
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocListener<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) {
          if (state is Idle && state.nextRoute != null) {
            Navigator.of(context, rootNavigator: true)
                .pushNamedAndRemoveUntil(state.nextRoute, (route) {
              return false;
            });
          } else if (state is Idle && state.nonFieldError?.isNotEmpty == true) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Authentication Failure')),
              );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
