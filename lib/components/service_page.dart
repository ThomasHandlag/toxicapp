import 'package:flutter/material.dart';
import 'package:toxicapp/api/api_connector.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});
  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  Future<Map<String, dynamic>> getPosts() async {
    final connector = ApiConnector(baseUrl: "http://127.0.0.1/api/v2");
    final response = connector.getPostsOrigin();
    return response.then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.95,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder(
            future: getPosts(),
            builder: (childContext, snap) {
              if (snap.connectionState == ConnectionState.done) {
                if (snap.hasData && snap.data!.isNotEmpty) {
                  final data = snap.data!['data'];
                  return ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Title: ${data[index]['title']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("Description: ${data[index]['body']}"),
                            ],
                          ),
                        );
                      },
                      itemCount: data!.length);
                } else {
                  return const Text("You don't have any posts");
                }
              } else if (snap.connectionState == ConnectionState.waiting) {
                return Container(
                    alignment: Alignment.center,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(
                       
                      ),
                    ));
              } else {
                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Network Error"),
                );
              }
            }));
  }
}
