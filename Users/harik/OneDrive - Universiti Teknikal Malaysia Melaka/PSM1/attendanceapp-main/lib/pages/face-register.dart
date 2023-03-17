import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FaceRegister extends StatefulWidget {
  final List<CameraDescription> cameras;

  FaceRegister({Key? key, required this.cameras, String? imagePath})
      : super(key: key);

  @override
  State<FaceRegister> createState() => _FaceRegisterState();
}

class _FaceRegisterState extends State<FaceRegister> {
  String? imagePath;
  File? file;
  String apiresponse = "Waiting..";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    getLink();
    loadurl();
    super.initState();
  }

  void getLink() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString("imagepath");
      file = File(imagePath!);
    });
  }

  void faceRegister() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString("imagepath");
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String url = prefs.getString("url") ?? "";
      FormData formData = FormData.fromMap({
        "userID": FirebaseAuth.instance.currentUser!.uid,
        "image1": await MultipartFile.fromFile(file!.path,
            filename: p.basename(imagePath!)),
      });

      final response = await Dio().post("$url/register", data: formData);
      setState(() {
        apiresponse = response.data['data'];
        if (apiresponse == "Face successfully registered!") {
          showTopSnackBar(
            context,
            const CustomSnackBar.success(
              message: "Face successfully registered!",
            ),
          );
          context.go("/");
        } else {
          showTopSnackBar(
            context,
            const CustomSnackBar.error(
              message:
                  "Something went wrong. Please check your server and try again",
            ),
          );
        }
      });
    } catch (e) {
      setState(() {
        apiresponse = e.toString();
      });
    }
  }

  void loadurl() async {
    final prefs = await SharedPreferences.getInstance();
    _controller.text = prefs.getString("url") ?? "";
  }

  void saveURL(String url) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("url", url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => faceRegister(),
        child: Icon(Icons.arrow_right_alt_outlined),
      ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          (file == null || imagePath == "")
              ? const Center(child: CircularProgressIndicator())
              : Image.file(file!),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'BaseURL',
                  ),
                ),
                ElevatedButton(
                    onPressed: () => saveURL(_controller.text),
                    child: Text("Save")),
                Text(apiresponse),
                Center(
                  child: ElevatedButton(
                      onPressed: () => context.go(
                            "/cameraview",
                          ),
                      child: Text("Open Camera")),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
