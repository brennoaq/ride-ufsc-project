import 'package:boilerplate_flutter/config/styles/default_button_style.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/modules/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return _bodyLogin();
  }
}

class _bodyLogin extends StatefulWidget {
  @override
  __bodyLoginState createState() => __bodyLoginState();
}

class __bodyLoginState extends State<_bodyLogin> {
  bool focusEmail = false;
  bool focusPassword = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is Idle) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/images/logo.svg',
                          width: 72, height: 72, color: Colors.green),
                      Text(
                        'Bem-vindo de volta',
                        style: TextStyle(
                          fontFamily: 'Courier Prime',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Egestas eget risus netus',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  focusEmail = hasFocus;
                                });
                              },
                              child: TextFormField(
                                controller: state.emailFieldState.controller,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF666362)),
                                    ),
                                    labelText: 'Digite seu email',
                                    contentPadding:
                                        EdgeInsets.only(top: 15, bottom: 8),
                                    prefixIcon: SvgPicture.asset(
                                      'assets/icons/ic_mail.svg',
                                      color: focusEmail
                                          ? Theme.of(context).primaryColor
                                          : Color(0xFF666362),
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      minHeight: 16,
                                      minWidth: 40,
                                    ),
                                    errorText: state.emailFieldState.error),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (email) {
                                  context
                                      .read<LoginBloc>()
                                      .add(OnFormChanged());
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  focusPassword = hasFocus;
                                });
                              },
                              child: TextFormField(
                                controller: state.passwordFieldState.controller,
                                enableSuggestions: false,
                                autocorrect: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF666362)),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 15, bottom: 8),
                                    labelText: 'Digite sua senha',
                                    prefixIcon: SvgPicture.asset(
                                      'assets/icons/ic_lock.svg',
                                      color: focusPassword
                                          ? Theme.of(context).primaryColor
                                          : Color(0xFF666362),
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      minHeight: 16,
                                      minWidth: 40,
                                    ),
                                    suffixIcon: ButtonTheme(
                                      padding: EdgeInsets.all(0),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minWidth: 0,
                                      height: 0,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: SvgPicture.asset(
                                          'assets/icons/ic_eye.svg',
                                          width: 20,
                                          color: focusPassword
                                              ? BoilerColors.white[40]
                                              : BoilerColors.white[64],
                                        ),
                                      ),
                                    ),
                                    errorText: state.passwordFieldState.error),
                                onChanged: (password) {
                                  context
                                      .read<LoginBloc>()
                                      .add(OnFormChanged());
                                },
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: getDefaultButtonStyle(),
                                child: Text(
                                  'Entrar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: state.isLoginButtonEnabled
                                    ? () {
                                        context
                                            .read<LoginBloc>()
                                            .logInWithCredentials();
                                      }
                                    : null,
                              ),
                            ),
                            TextButton(
                              child: Text(
                                'Esqueceu sua senha?',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
