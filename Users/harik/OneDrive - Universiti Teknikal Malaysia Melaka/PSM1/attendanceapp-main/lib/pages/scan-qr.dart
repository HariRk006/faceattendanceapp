import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ScanQR extends StatefulWidget {
  ScanQR({Key? key}) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String _scanBarcode = 'Unknown';
  String _classcode = "";
  String _subject = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  String apiresponse = "Empty";

  @override
  void initState() {
    super.initState();
    // loadurl();
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

  Future<void> scanQR() async {
    String barcodeScanRes;
    final prefs = await SharedPreferences.getInstance();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);

      final docRef = await db
          .collection("activeclass")
          .doc(barcodeScanRes)
          .collection("enrolled")
          .doc(FirebaseAuth.instance.currentUser?.uid);
      final classInfo = await db.collection("activeclass").doc(barcodeScanRes);
      docRef.get().then(
        (value) {
          if (value.exists) {
            classInfo.get().then(((value) {
              setState(() {
                _classcode =  value.data()!['classCode'];
                _subject =  value.data()!['subjectName'];
                _scanBarcode = "Attendance marked!";
                 prefs.setString("result", _scanBarcode);
                 prefs.setString("subject", _subject);
                 prefs.setString("code", _classcode);

              });
            })).then((value) => context.go("/attendanceresult"));
          } else {
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                message: "You did not enroll for this course!",
              ),
            );
            setState(() {
              _scanBarcode = "You did not enroll for this course!";
              prefs.setString("result", _scanBarcode);
              print("You did not enroll for this course!");
            });
          }
        },
        onError: (e) => print("Error getting document: $e"),
      );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => scanQR(),
        child: Icon(Icons.qr_code),
      ),
      appBar: AppBar(
        title: Text('Scan QR'),
        actions: [
          IconButton(
            icon: Icon(Icons.lock),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
