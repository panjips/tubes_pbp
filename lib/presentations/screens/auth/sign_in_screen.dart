import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/model/user.dart';
import 'package:test_slicing/data/repository/auth_repository.dart';
import 'package:test_slicing/data/repository/destinasi_respository.dart';
import 'package:test_slicing/data/repository/ticket_repository.dart';
import 'package:test_slicing/data/repository/ulasan_repository.dart';
import 'package:test_slicing/presentations/screens/auth/sign_up_screen.dart';
import 'package:test_slicing/presentations/widgets/auth_button.dart';
import 'package:test_slicing/presentations/widgets/divider.dart';
import 'package:test_slicing/presentations/widgets/google_container.dart';
import 'package:test_slicing/presentations/widgets/input_form.dart';
import 'package:test_slicing/presentations/widgets/snackbar.dart';
import 'package:test_slicing/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool passwordVisible = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _askPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    _askPermission();
    super.initState();
  }

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
                      "Sign in to start your journey",
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
                padding: const EdgeInsets.only(left: 36, right: 36, bottom: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // await AuthRepository().registerUser(userTesting);
                          // User userLogin = await AuthRepository()
                          //     .loginUser("trisna", "123456");

                          // print(userLogin);
                          // await AuthRepository().showProfile("6");

                          // await AuthRepository().getAllUserFromApi();

                          // await AuthRepository().updateUser(userTesting, '5');
                          // await DestinasiRepositroy().getAllDestinasiFromApi();

                          // await DestinasiRepositroy().getDestinasiFromApi('1');
                          // await TicketRepository().showUserTicket('2');
                        },
                        child: GoogleButton(size, "Sign in"),
                      ),
                      DividerAuth(),
                      Form(
                        child: Column(
                          children: [
                            inputForm(
                              (p0) {},
                              controller: username,
                              hintText: "Username",
                              key: const Key('Username'),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              width: size.width,
                              height: 48,
                              child: TextFormField(
                                key: const Key('Password'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Username atau Email tidak boleh kosong!";
                                  }
                                  return null;
                                },
                                obscureText: !passwordVisible,
                                textAlignVertical: TextAlignVertical.bottom,
                                controller: password,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  hintText: "Password",
                                  hintStyle: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: slate400,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: slate300),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            AuthButton(() async {
                              User? data = await AuthRepository()
                                  .loginUser(username.text, password.text);
                              saveBase64Profile(data.urlPhoto ?? defaultImage);
                              // print(data);
                              // User? data = await AuthRepository().userLogin(
                              //     username: username.text,
                              //     password: password.text);
                              if (data != null) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                    showSnackBar(
                                        "Success!",
                                        "Berhasil masuk, selamat menjelajah",
                                        ContentType.success));
                                saveId(data.id!);
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacementNamed(context, '/nav');
                              }
                            }, size: size, text: "Sign in", key: const Key('loginButton')),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don’t have an account yet?",
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
                                  builder: (context) => SignUpScreen(),
                                )),
                            child: const Text(
                              " Sign Up",
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  saveBase64Profile(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .setString('base64profile', id)
        .then((value) => print("Success set base64profile"))
        .onError((error, stackTrace) => print("Error : $error"));
  }

  saveId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .setString('id_user', id)
        .then((value) => print("Success set id user $id"))
        .onError((error, stackTrace) => print("Error : $error"));
  }

  User userTesting = User(
      email: "user1@gmail.com",
      username: "user1",
      password: "password1",
      firstName: "John",
      lastName: "Doe",
      birthDate: "1990-05-15",
      jenisKelamin: "Perempuan");
}
