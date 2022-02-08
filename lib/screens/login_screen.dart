import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/app_language.dart';
import 'package:flutter_mis/providers/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hidePassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();

  String _userName;
  String _password;

  Future<void> _sumitLoginButton() async {
    FocusScope.of(context).unfocus();
    bool valid = _formKey.currentState.validate();
    if (!valid) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<User>(context, listen: false)
          .login(_userName, _password);
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      final scafmessage = ScaffoldMessenger.of(context);

      scafmessage.showSnackBar(SnackBar(
        content: Text(
          error,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  @override
  void dispose() {
    _passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/images/top_login.svg',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      alignment: AlignmentDirectional.topEnd,
                      onPressed: () {
                        Provider.of<AppLanguage>(context, listen: false)
                            .changeLanguage();
                      },
                      icon: Icon(
                        Icons.language,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context).login,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).login_continous,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              key: ValueKey('userName'),
                              autocorrect: false,
                              enableSuggestions: false,
                              textDirection: TextDirection.ltr,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                ),
                                iconColor:
                                    Theme.of(context).colorScheme.primary,
                                label:
                                    Text(AppLocalizations.of(context).username),
                                border: UnderlineInputBorder(),
                              ),
                              onSaved: (value) {
                                _userName = value.trim();
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return AppLocalizations.of(context)
                                      .error_username;
                                return null;
                              },
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_passwordFocus),
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              key: ValueKey('password'),
                              focusNode: _passwordFocus,
                              textDirection: TextDirection.ltr,
                              autocorrect: false,
                              enableSuggestions: false,
                              obscureText: _hidePassword,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.lock,
                                ),
                                iconColor:
                                    Theme.of(context).colorScheme.primary,
                                label:
                                    Text(AppLocalizations.of(context).password),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _hidePassword = !_hidePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _hidePassword
                                          ? Icons.visibility_sharp
                                          : Icons.visibility_off_sharp,
                                    )),
                                border: UnderlineInputBorder(),
                              ),
                              onSaved: (value) {
                                _password = value.trim();
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return AppLocalizations.of(context)
                                      .error_password;
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                        ),
                        child: _isLoading
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text(AppLocalizations.of(context).login),
                        onPressed: _sumitLoginButton,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Positioned(
                    bottom: -40,
                    child: Transform(
                      alignment: AlignmentDirectional.center,
                      transform: Matrix4.rotationY(
                          Provider.of<AppLanguage>(context, listen: false).isRTl
                              ? math.pi
                              : 0),
                      child: SvgPicture.asset(
                        'assets/images/bottom_login.svg',
                        width: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
