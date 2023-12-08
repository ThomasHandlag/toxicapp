import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {
  const EditPost({super.key, this.id});
  final int? id;
  @override
  State<EditPost> createState() => _EditPost();
}

class _EditPost extends State<EditPost> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10.0),
          child: Form(
            child: Column(children: [
              Container(
                margin: const EdgeInsets.all(20.0),
                child: TextFormField(autocorrect: true),
              )
            ]),
          )),
    ));
  }
}
