import 'package:attendance2/pages/attendanceresult.dart';
import 'package:attendance2/pages/authpage.dart';
import 'package:attendance2/pages/camerapage.dart';
import 'package:attendance2/pages/face-register.dart';
import 'package:attendance2/pages/home.dart';
import 'package:attendance2/pages/login.dart';
import 'package:attendance2/pages/register.dart';
import 'package:attendance2/pages/scan-qr.dart';
import 'package:attendance2/pages/verifyFacepage.dart';
import 'package:attendance2/web/web-qr.dart';
import 'package:camera/camera.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final cameras = await availableCameras();
  runApp(App(cameras: cameras));
}

class App extends StatelessWidget {
  List<CameraDescription> cameras;
  App({Key? key, required this.cameras}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        debugShowCheckedModeBanner: false,
      );
  late final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => ScanQR(),
      ),
      GoRoute(
        path: '/authpage',
        builder: (BuildContext context, GoRouterState state) => AuthPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      GoRoute(
          path: "/showqr",
          builder: (BuildContext context, GoRouterState state) => WebHome()),
      GoRoute(
          path: "/scanqr",
          builder: (BuildContext context, GoRouterState state) => ScanQR()),
      GoRoute(
          path: "/attendanceresult",
          builder: (BuildContext context, GoRouterState state) =>
              AttendanceResult()),
      GoRoute(
          path: "/face-register",
          builder: (BuildContext context, GoRouterState state) => FaceRegister(
                cameras: cameras,
              )),
      GoRoute(
          path: "/cameraview",
          builder: (BuildContext context, GoRouterState state) => CameraView(
                cameras: cameras,
              )),
      GoRoute(
          path: "/verifycameraview",
          builder: (BuildContext context, GoRouterState state) =>
              VerifyFaceCamera(
                cameras: cameras,
              )),
    ],
  );
}
