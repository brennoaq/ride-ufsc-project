import 'package:boilerplate_flutter/config/styles/default_button_style.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) {
        LoginBloc tempBloc = LoginBloc();
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocConsumer<LoginBloc, LoginState>(
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
        builder: (BuildContext context, LoginState state) {
          return Scaffold(
            body: SafeArea(
              child: _getBody(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(BuildContext context, LoginState state) {
    if (state is Idle) {
      return SingleChildScrollView(
        child: LoginForm(state, _formKey),
      );
    } else if (state is Error) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Text(state.error.toString()),
            ElevatedButton(
              onPressed: () {
                context.read<LoginBloc>().add(OnFormChanged());
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
