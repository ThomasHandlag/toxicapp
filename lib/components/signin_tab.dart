import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toxicapp/api/api_connector.dart';
import 'package:toxicapp/components/main_screen.dart';

class SignInTab extends StatefulWidget {
  const SignInTab({super.key});

  @override
  State<StatefulWidget> createState() => _SignInTab();
}

class _SignInTab extends State<SignInTab> {
  final ApiConnector _connector =
      ApiConnector(baseUrl: "http://127.0.0.1:80/api/v2");

  final Map<String, String> _formData = {
    'email': '',
    'password': '',
  };

  bool _isShowPassword = false;

  final _formKey = GlobalKey<FormState>();

  void signIn() {
    if (_formKey.currentState!.validate()) {
      final response = _connector.signIn(
          _formData['email'] ?? '', _formData['password'] ?? '');
      response.then((value) {
        if (value['success'] == true) {
          storeData(response);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePage(isSignin: true)));
        } else {
          const snackBar = SnackBar(
            content: Text("Login Failed"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((e) {
        dev.log(e.toString());
      });
    }
  }

  void storeData(Future<Map<String, dynamic>> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    data.then((value) {
      prefs.setString('user_data', json.encode(value));
    });
    prefs.setBool('no_auth', false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill your email address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _formData['email'] = value;
                    });
                  },
                  onFieldSubmitted: (value) {
                    signIn();
                  },
                  autocorrect: true,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    icon: Icon(Icons.email),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill your password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _formData['password'] = value;
                    });
                  },
                  onFieldSubmitted: (value) {
                    signIn();
                  },
                  obscureText: _isShowPassword,
                  autocorrect: true,
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
                              : const Icon(Icons.visibility_off))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      signIn();
                    },
                    child: const Text("Sign In")),
              ),
            ]),
      ),
    );
  }
}
