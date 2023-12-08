import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toxicapp/components/main_screen.dart';
import 'package:toxicapp/components/preview_app.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<StatefulWidget> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  Future<bool> isFirstDownload() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('no_auth') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
        future: isFirstDownload(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return const PreviewApp();
            } else {
              return const HomePage(
                isSignin: true,
              );
            }
          } else {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 5.0,
              value: 0,
            ));
          }
        },
      ),
    );
  }
}
