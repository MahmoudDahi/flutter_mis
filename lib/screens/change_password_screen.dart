import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/user.dart';
import 'package:flutter_mis/remote/exception_error.dart';
import 'package:provider/provider.dart';

import '../remote/constant.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change-password';
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var _hideCurrentPassword = true;
  var _hideNewPassword = true;
  var _hideConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  String _currentPassword;
  final _newPasswordController = TextEditingController();

  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitChangePassword() async {
    bool valid = _formKey.currentState.validate();
    if (valid) {
      _formKey.currentState.save();

      String _errorFailed;
      showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
          children: [
            Constant.loadingProgress(context),
          ],
        ),
      );
      try {
        await Provider.of<User>(context, listen: false).changePassword(
            _currentPassword, _newPasswordController.text.trim());
        _errorFailed = null;
      } on ExceptionError catch (_) {
        _errorFailed =
            AppLocalizations.of(context).error_current_password_not_correct;
      } catch (_) {
        _errorFailed = AppLocalizations.of(context).some_error_happend;
      } finally {
        Navigator.of(context).pop();
      }
      showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: _errorFailed == null
              ? Colors.green[400]
              : Theme.of(context).errorColor,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                AppLocalizations.of(context).change_password,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _errorFailed == null
                    ? AppLocalizations.of(context).change_password_success
                    : _errorFailed,
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  AppLocalizations.of(context).confirm,
                  style: TextStyle(
                    color: _errorFailed == null
                        ? Colors.green[400]
                        : Theme.of(context).errorColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).change_password),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      key: ValueKey('current password'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_newPasswordFocus),
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: _hideCurrentPassword,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        label:
                            Text(AppLocalizations.of(context).current_password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _hideCurrentPassword = !_hideCurrentPassword;
                              });
                            },
                            icon: Icon(
                              _hideCurrentPassword
                                  ? Icons.visibility_sharp
                                  : Icons.visibility_off_sharp,
                            )),
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _currentPassword = value.trim();
                      },
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context).error_password;
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      key: ValueKey('new password'),
                      textDirection: TextDirection.ltr,
                      focusNode: _newPasswordFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_confirmPasswordFocus),
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: _hideNewPassword,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context).new_password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _hideNewPassword = !_hideNewPassword;
                              });
                            },
                            icon: Icon(
                              _hideNewPassword
                                  ? Icons.visibility_sharp
                                  : Icons.visibility_off_sharp,
                            )),
                        border: OutlineInputBorder(),
                      ),
                      controller: _newPasswordController,
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context).error_password;
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      key: ValueKey('confirm password'),
                      textDirection: TextDirection.ltr,
                      focusNode: _confirmPasswordFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _submitChangePassword();
                      },
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: _hideConfirmPassword,
                      decoration: InputDecoration(
                        label:
                            Text(AppLocalizations.of(context).confirm_password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _hideConfirmPassword = !_hideConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _hideConfirmPassword
                                  ? Icons.visibility_sharp
                                  : Icons.visibility_off_sharp,
                            )),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context).error_password;
                        if (value.trim() != _newPasswordController.text.trim())
                          return AppLocalizations.of(context)
                              .error_confirm_password;
                        return null;
                      },
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
