import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImagePicker _picker = ImagePicker();
  String apiresponse = "Empty";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadurl();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kIsWeb) {
          context.go("/showqr");
        } else {
          context.go('/authpage');
        }
      }
    });
  }

  void loadurl() async {
    final prefs = await SharedPreferences.getInstance();
    _controller.text = prefs.getString("url") ?? "";
  }

  void saveURL(String url) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("url", url);
  }

  void checkApi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String url = prefs.getString("url") ?? "";

      print(url);
      final response = await Dio().get(url);
      setState(() {
        apiresponse = response.data;
      });
    } catch (e) {
      setState(() {
        apiresponse = e.toString();
      });
    }
  }

  void registerFace(XFile? facePic) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String url = prefs.getString("url") ?? "";
      FormData formData = FormData.fromMap({
        "userID": FirebaseAuth.instance.currentUser!.uid,
        "image1":
            await MultipartFile.fromFile(facePic!.path, filename: facePic.name),
      });

      final response = await Dio().post("$url/register", data: formData);
      setState(() {
        apiresponse = response.data['data'];
      });
    } catch (e) {
      setState(() {
        apiresponse = e.toString();
      });
    }
  }

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
        apiresponse = response.data['data']['verified'].toString();
      });
    } catch (e) {
      setState(() {
        apiresponse = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.lock),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => context.go('/scanqr')),
        child: Icon(Icons.qr_code_2),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //     onPressed: () => context.go('/scanqr'), child: Text("Scan QR")),
            // ElevatedButton(
            //   onPressed: () => FirebaseAuth.instance.signOut(),
            //   child: Text("Sign out"),
            // ),
            // ElevatedButton(
            //     onPressed: () => checkApi(), child: Text("Check API")),
            // ElevatedButton(
            //     onPressed: () async {
            //       final XFile? photo =
            //           await _picker.pickImage(source: ImageSource.camera);

            //       print(photo?.path);
            //       registerFace(photo);
            //     },
            //     child: const Text("Register Face")),
            // ElevatedButton(
            //     onPressed: () async {
            //       final XFile? photo =
            //           await _picker.pickImage(source: ImageSource.camera);

            //       print(photo?.path);
            //       checkFace(photo);
            //     },
            //     child: const Text("Verify Face")),
            // Text(apiresponse)
          ],
        ),
      ),
    );
  }
}
