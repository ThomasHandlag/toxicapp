import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

import 'package:toxicapp/api/api_connector.dart';
import 'package:toxicapp/components/update_profile.dart';
import 'package:toxicapp/theme/color_schemes.g.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.id});
  final int? id;
  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final connector = ApiConnector(baseUrl: "http://127.0.0.1/api/v2");

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

  Future<Map<String, dynamic>> getPosts(id) async {
    final response = connector.getPosts(id);
    return response.then((value) => value);
  }

  void toUpdateProfile(int id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UpdateProfile(uid: id)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            final data = snapshot.data;
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  top: 10.0, left: 20, right: 20, bottom: 10.0),
              padding: const EdgeInsets.all(10.0),
              // decoration: const BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage("images/bg_image.png"),
              //     )
              //     ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.28,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          boxShadow: const [
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 1,
                                blurStyle: BlurStyle.solid)
                          ],
                          color: Theme.of(context).colorScheme.primary),
                      child: GestureDetector(
                        onTap: () {
                          toUpdateProfile(data['id']);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (data!['img_link'] != null
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "http://127.0.0.1/${data['img_link']}"),
                                            fit: BoxFit.fill)),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: const Icon(
                                      Icons.person,
                                      weight: 100,
                                      size: 100,
                                      color: Colors.blueGrey,
                                    ),
                                  )),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                data['name'] ?? 'Undefined',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    decorationStyle: TextDecorationStyle.solid),
                              ),
                            )
                          ],
                        ),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      "Your posts",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      margin: const EdgeInsets.all(2.0),
                      child: FutureBuilder(
                          future: getPosts(data['id']),
                          builder: (childContext, snap) {
                            if (snap.connectionState == ConnectionState.done) {
                              if (snap.hasData && snap.data!.isNotEmpty) {
                                final data = snap.data!['posts'];
                                return ListView.builder(
                                    itemBuilder: (context, index) {
                                      return CardItem(
                                        title: data[index]['title'],
                                        content: data[index]['body'],
                                        id: data[index]['id'],
                                      );
                                    },
                                    itemCount: data!.length);
                              } else {
                                return const Text("You don't have any posts");
                              }
                            } else if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                  alignment: Alignment.center,
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.purple,
                                    ),
                                  ));
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("Network Error"),
                              );
                            }
                          }))
                ],
              ),
            );
          } else {
            return Container(
                alignment: Alignment.center,
                child: const Text("Error",
                    style: TextStyle(color: Colors.red, fontSize: 30)));
          }
        } else {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
      },
      future: getLocalData(),
    );
  }
}

class CardItem extends StatefulWidget {
  const CardItem(
      {super.key,
      required this.title,
      required this.content,
      required this.id});
  final String title;
  final String content;
  final int id;
  @override
  State<CardItem> createState() => _CardItem();
}

class _CardItem extends State<CardItem> {
  final connector = ApiConnector(baseUrl: "http://127.0.0.1/api/v2");
  void deletePost() {
    connector.deletePost(widget.id).then((value) {
      if (value['success'] == true) {
        const snackBar = SnackBar(
          content: Text('Deleted post!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 200.0,
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(2.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Title: ${widget.title}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("Description: ${widget.content}"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    deletePost();
                  },
                  child: const Text("Remove"))
            ],
          )
        ]),
      ),
    );
  }
}
