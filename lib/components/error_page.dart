import 'package:flutter/material.dart';
import 'package:toxicapp/api/api_connector.dart';
import 'dart:developer' as dev;

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<StatefulWidget> createState() => _ErrorPage();
}

class _ErrorPage extends State<ErrorPage> {
  Future<Map<String, dynamic>> getErrors() async {
    final connector = ApiConnector(baseUrl: "http://127.0.0.1/api/v2");
    final response = connector.getErrors();
    return response.then((value) => value);
  }

  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                    )
                  ]),
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.1 - 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                     SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface,),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        autocorrect: true,
                        onChanged: (value) {
                          setState(() {
                            _searchText = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              alignment: Alignment.topCenter,
              child: FutureBuilder(
                  future: getErrors(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        final temp = snapshot.data!['data'];
                        final data = [];
                        temp.forEach((element) {
                          if (element['error']
                              .toString()
                              .toLowerCase()
                              .contains(_searchText.toLowerCase())) {
                            data.add(element);
                          }
                        });
                        return Container(
                            alignment: Alignment.topCenter,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return ExpansionTile(
                                    leading: const Icon(Icons.star),
                                    title: Text(
                                      "${data[index]['error']}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Icon(
                                        Icons.arrow_drop_down_circle, color: Theme.of(context).colorScheme.onSurface,),
                                    children: [
                                      ListTile(
                                        title: Text(
                                            "Reasion: ${data[index]['reason'] ?? "No Reason"}"),
                                      ),
                                      ListTile(
                                        title: Text(
                                            "Solution: ${data[index]['solution'] ?? "No Solution"}"),
                                      ),
                                      ListTile(
                                        title: Text(
                                            "Description: ${data[index]['description'] ?? "No Description"}"),
                                      ),
                                      ListTile(
                                        title: Text(
                                            "#${data[index]['tags'] ?? "No Tags"}"),
                                      ),
                                      const ListTile(
                                        title: Text("Image",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: (data[index]['img'] != null
                                            ? Image.network(
                                                "http://127.0.0.1/${data[index]['img']}")
                                            : Container(
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0))),
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  size: 100,
                                                ),
                                              )),
                                      )
                                    ],
                                  );
                                }));
                      } else {
                        return const Text("Error");
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return const Text("Network Error");
                    }
                  }),
            )
          ],
        ));
  }
}
