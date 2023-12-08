import 'package:flutter/material.dart';
import 'package:toxicapp/api/api_connector.dart';
import 'dart:developer' as dev;

class AddPage extends StatefulWidget {
  const AddPage({super.key, this.id});
  final int? id;
  @override
  State<AddPage> createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    'title': '',
    'description': '',
  };

  final connector = ApiConnector(baseUrl: "http://127.0.0.1/api/v2");

  void addPost() {
    if (_formKey.currentState!.validate()) {
      connector
          .addPost(_formData['title'] ?? '', _formData['description'] ?? '',
              widget.id ?? -1)
          .then((value) {
        if (value['success'] == true) {
          const snackBar = SnackBar(
            content: Text('Yay! Post its done!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        ;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (value) {
                        _formData['title'] = value;
                      },
                      onFieldSubmitted: (value) {
                        addPost();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else {
                          return null;
                        }
                      },
                      autocorrect: true,
                      maxLines: 6,
                      decoration: const InputDecoration(
                          labelText: "Title", border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (value) {
                        _formData['description'] = value;
                      },
                      onFieldSubmitted: (value) {
                        addPost();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else {
                          return null;
                        }
                      },
                      autocorrect: true,
                      maxLines: 6,
                      decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addPost();
                      },
                      child: const Text("Post"))
                ],
              )),
        ));
  }
}
