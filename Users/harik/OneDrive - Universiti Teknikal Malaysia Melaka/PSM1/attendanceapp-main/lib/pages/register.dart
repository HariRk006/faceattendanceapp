import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('E5E5E5'),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: "loginImg",
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: HexColor("14213D"),
                  child: SvgPicture.asset("assets/login.svg"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Sign up",
                style: TextStyle(
                    fontFamily: GoogleFonts.openSans().fontFamily,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: HexColor('14213D')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Text("Have an account?"),
                  TextButton(
                      onPressed: () => context.go("/login"),
                      child: const Text("Sign in instead"))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 12),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 12),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Confirm Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: OutlinedButton(
                onPressed: () => context.go("/face-register"),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Let's Get Started",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
