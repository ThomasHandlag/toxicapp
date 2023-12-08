import 'package:flutter/material.dart';
import 'package:toxicapp/components/signin_tab.dart';
import 'package:toxicapp/components/signup_tab.dart';
import 'dart:developer' as dev;

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignScreen();
}

class _SignScreen extends State<SignScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2, // Number of tabs
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const[
          SignInTab(),
          SignUpTab()
        ],
      ),
      appBar: TabBar(
        tabs: const [
          Tab(
            text: "Sign In",
            icon: Icon(Icons.login),
          ),
          Tab(text: "Sign up", icon: Icon(Icons.app_registration))
        ],
        controller: _tabController,
      ),
    );
  }
}
