import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    const providerConfigs = [
      EmailProviderConfiguration(),
    ];

    final height = MediaQuery.of(context).size.height - 24;
    return Scaffold(
        backgroundColor: HexColor('E5E5E5'),
        body: SignInScreen(
          resizeToAvoidBottomInset: true,
          providerConfigs: providerConfigs,
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              context.go("/face-register");
            }),
          ],
        ));
  }
}
