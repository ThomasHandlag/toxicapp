import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:toxicapp/api/api_connector.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key, this.uid});
  final int? uid;
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String path = "";
  File? file;

  Future<void> chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File temp = File(result.files.single.path!);
      setState(() {
        path = temp.path;
        file = temp;
      });
    } else {
      // User canceled the picker
    }
  }

  void uploadProfile() {
    final connector = ApiConnector(baseUrl: "http://127.0.0.1/api/v2");
    final response = connector.uploadProfile(widget.uid, file);
    response.then((value) {
      final snackBar = SnackBar(
        content: Text(value['success'] ? "Yay! Upload done!" : "Upload Failed"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update Profile"),
        ),
        body: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20.0),
          child: Form(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                GestureDetector(
                    onTap: chooseFile,
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSecondary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          )),
                      child: (path.isNotEmpty
                          ? Image.file(File(path))
                          : Icon(
                              Icons.person,
                              size: 100,
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                    )),
                ElevatedButton(
                  onPressed: uploadProfile,
                  child: const Text("Upload"),
                )
              ])),
        ));
  }
}
