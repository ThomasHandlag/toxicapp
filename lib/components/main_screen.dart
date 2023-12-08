import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toxicapp/components/add_page.dart';
import 'package:toxicapp/components/error_page.dart';
import 'package:toxicapp/components/home_page.dart';
import 'package:toxicapp/components/service_page.dart';
import 'package:toxicapp/components/setting_page.dart';
import 'dart:developer' as dev;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.isSignin});

  final bool isSignin;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StatefulWidget getPage(id) {
    if (index == 0) {
      return MainPage(id: id);
    } else if (index == 1) {
      return const ServicePage();
    } else if (index == 2) {
      return AddPage(id: id);
    } else if (index == 3) {
      return const ErrorPage();
    } else {
      return SettingsScreen(id: id);
    }
  }

  static int index = 0;

  void setPage(int index) async {
    index = index;
  }

  Future<Map<String, dynamic>> getLocalData() async {
    Map<String, dynamic> data = {};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString('user_data');
    if (userData != null && userData.isNotEmpty) {
      data = jsonDecode(userData)['user'];
      return data;
    } else {
      return Future.error("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
              key: Key("1"),
            ),
            NavigationDestination(
              icon: Icon(Icons.miscellaneous_services),
              label: "Add",
              key: Key("5"),
            ),
            NavigationDestination(
              icon: Icon(Icons.add),
              label: "Add",
              key: Key("2"),
            ),
            NavigationDestination(
              icon: Icon(Icons.bug_report),
              label: "Errors",
              key: Key("3"),
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: "Settings",
              key: Key("4"),
            ),
          ],
          onDestinationSelected: (value) {
            setState(() {
              index = value;
            });
          },
          selectedIndex: index,
        ),
        body: FutureBuilder(
            future: getLocalData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return getPage(snapshot.data!['id']);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Network Error"),
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                    ));
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Network Error"),
                );
              }
            }));
  }
}
