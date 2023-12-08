import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toxicapp/api/api_connector.dart';
import 'package:toxicapp/components/sign_screen.dart';
import 'package:toxicapp/components/update_profile.dart';
import 'dart:developer' as dev;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.id});
  final int? id;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _newPassword = "";
  Color selectedColor = const Color.fromARGB(255, 255, 255, 255);
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      MaterialButton(
                        onPressed: () => _updateProfile(context),
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(20.0),
                        child: const Text('Update Profile'),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'New Password',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _newPassword = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _changePassword(context),
                        child: const Text('Change Password'),
                      ),
                      const SizedBox(height: 16),
                      MaterialButton(
                        onPressed: () => _logoutUser(context),
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enableFeedback: true,
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              )));
    });
  }

  // void _showColorPicker(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Pick a color'),
  //         content: SingleChildScrollView(
  //           child: ColorPicker(
  //             pickerColor: selectedColor,
  //             onColorChanged: (Color color) {
  //               setState(() {
  //                 selectedColor = color;
  //               });
  //             },
  //             pickerAreaHeightPercent: 0.8,
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _changeThemeColor(selectedColor);
  //             },
  //             child: const Text('Select'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _logoutUser(BuildContext context) {
    _clearSharedPreferences(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignScreen()));
  }

  void _clearSharedPreferences(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _changePassword(BuildContext context) {
    final connector = ApiConnector(baseUrl: "http://127.0.0.1/api/v2");
    final response = connector.changePassword(widget.id, _newPassword);
    response.then((value) {
      dev.log(value.toString());
      if (value['success'] == true) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignScreen()));
      } else {
        const snackBar = SnackBar(
          content: Text("Failed"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  void _updateProfile(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UpdateProfile(uid: widget.id)));
  }
}
