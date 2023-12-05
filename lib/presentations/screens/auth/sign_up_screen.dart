import 'package:flutter/material.dart';
import 'package:test_slicing/presentations/screens/auth/registrasi_screen.dart';
import 'package:test_slicing/presentations/screens/auth/sign_in_screen.dart';
import 'package:test_slicing/presentations/widgets/auth_button.dart';
import 'package:test_slicing/utils/constant.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: slate50,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image(
                    fit: BoxFit.fitWidth,
                    width: size.width,
                    image: const AssetImage('images/auth-banner.png'),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 36, right: 36, top: 12),
                    child: Text(
                      "Sign up to start your journey",
                      style: TextStyle(
                        height: 1.2,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                        color: slate900,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 36, right: 36, bottom: 12),
                child: Column(
                  children: [
                    AuthButton(
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrasiScreen(),
                            ));
                      },
                      size: size,
                      text: "Sign up With Email",
                      marginTop: 0.0,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: slate500),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              )),
                          child: const Text(
                            " Sign in",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: blue600),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
