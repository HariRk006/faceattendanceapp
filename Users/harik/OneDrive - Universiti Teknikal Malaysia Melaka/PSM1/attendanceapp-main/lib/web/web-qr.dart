import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WebHome extends StatefulWidget {
  WebHome({Key? key}) : super(key: key);

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: QrImage(
                    data: "4PxqScVaRqH9L96LcyGQ",
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: QrImage(
                    data: "HsJddNJpznBmzlLqBfxK",
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: QrImage(
                    data: "aOHEh0LPIq45Se3vSUyd",
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: QrImage(
                    data: "nfFwxDcNbHD2Wo1QoEB7",
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
