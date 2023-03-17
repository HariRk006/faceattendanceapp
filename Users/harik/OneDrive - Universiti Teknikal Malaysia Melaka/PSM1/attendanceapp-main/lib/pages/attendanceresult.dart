import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AttendanceResult extends StatefulWidget {
  AttendanceResult({Key? key}) : super(key: key);

  @override
  State<AttendanceResult> createState() => _AttendanceResultState();
}

class _AttendanceResultState extends State<AttendanceResult> {
  final ImagePicker _picker = ImagePicker();

  String _result = "";
  String _class = "";
  String _code = "";
  String apiresponse = "Empty";
  bool isfaceSuccessful = false;

  @override
  void initState() {
    getResult();
    super.initState();
  }

  // Future<bool> verify() async {
  //   // return checkFace(photo);
  // }

  void checkFace(XFile? facePic) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String url = prefs.getString("url") ?? "";
      FormData formData = FormData.fromMap({
        "userID": FirebaseAuth.instance.currentUser!.uid,
        "image1":
            await MultipartFile.fromFile(facePic!.path, filename: facePic.name),
      });

      final response = await Dio().post("$url/check", data: formData);

      setState(() {
        if (response.data['data']['verified'] == false) {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: "Face verification failed!",
            ),
          );
        } else {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: "Face verification successful!",
            ),
          );
        }
        isfaceSuccessful = response.data['data']['verified'];
      });
    } catch (e) {
      setState(() {
        apiresponse = e.toString();
      });
    }
  }

  void getResult() async {
    await SharedPreferences.getInstance().then((value) {
      setState(() {
        _result = value.getString("result")!;
        _class = value.getString("subject")!;
        _code = value.getString("code")!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go("/"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final XFile? photo =
              await _picker.pickImage(source: ImageSource.camera);
          checkFace(photo);
        },
        child: Icon(
          Icons.fingerprint,
        ),
      ),
      body: Container(
        child: Center(
          child: isfaceSuccessful
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text("$_result"), Text("$_class"), Text("$_code")])
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
