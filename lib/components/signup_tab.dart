import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:toxicapp/api/api_connector.dart';

class SignUpTab extends StatefulWidget {
  const SignUpTab({super.key});
  @override
  State<StatefulWidget> createState() => _SignUpTab();
}

class _SignUpTab extends State<SignUpTab> {
  final ApiConnector _connector =
      ApiConnector(baseUrl: "http://127.0.0.1/api/v2");

  final Map<String, String> _formData = {
    'email': '',
    'password': '',
    'username': '',
  };

  bool _isShowPassword = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isRegistSuccess = false;

  void signUp() {
    if (_formKey.currentState!.validate()) {
      dev.log(_formData['email'] ?? 'none');
      final response = _connector.signUp(_formData['username'] ?? '',
          _formData['password'] ?? '', _formData['email'] ?? '');
      response.then((value) => setState(() {
            if (value['success'] == true) {
              _isRegistSuccess = true;
            }
          }));
      // _tabController.index = 0;
    }
  }

  bool validateEmail(String email) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return regex.hasMatch(email);
  }

  dynamic validatePassword(String password) {
    if (password.length < 8) {
      return "Must be at least 8 characters";
    }
    if (!RegExp(r'^[A-Z]').hasMatch(password)) {
      return "Must be stated with an uppercase letter";
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return "Must contain at least one digit";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Contain at least one lowercase letter";
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Must contain at least one special character";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                    autocorrect: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill your name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _formData['username'] = value;
                      });
                    },
                    onFieldSubmitted: (value) {
                      signUp();
                    },
                    decoration: const InputDecoration(
                      labelText: "Your name",
                      icon: Icon(Icons.person),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                    autocorrect: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill your email';
                      } else if (value.isNotEmpty && !validateEmail(value)) {
                        return "Invalid email address";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _formData['email'] = value;
                      });
                    },
                    onFieldSubmitted: (value) {
                      signUp();
                    },
                    decoration: const InputDecoration(
                      labelText: "Your email",
                      icon: Icon(Icons.email),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                    autocorrect: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill your password';
                      } else if (value.isNotEmpty) {
                        return validatePassword(value);
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _formData['password'] = value;
                      });
                    },
                    onFieldSubmitted: (value) {
                      signUp();
                    },
                    obscureText: _isShowPassword,
                    decoration: InputDecoration(
                        labelText: "Password",
                        icon: const Icon(Icons.key),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isShowPassword = !_isShowPassword;
                              });
                            },
                            icon: _isShowPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off)))),
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      signUp();
                    },
                    child: const Text('Sign Up'),
                  )),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _isRegistSuccess
                      ? const Text(
                          "Successfully registered, please log you in!")
                      : const Text("")),
            ],
          ),
        ));
  }
}
