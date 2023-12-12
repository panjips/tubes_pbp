import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_pbp/data/model/user.dart';
import 'package:tubes_pbp/data/repository/auth_repository.dart';
import 'package:tubes_pbp/presentations/widgets/full_screen_image.dart';
import 'package:tubes_pbp/utils/constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? data;

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = prefs.getString('id_user');
    User? userData = await AuthRepository().showProfile(idUser!);
    setState(() {
      data = userData;
      Future.delayed(const Duration(seconds: 5));
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    if (data == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: size.width,
            height: size.height * (1 / 4),
            decoration: const BoxDecoration(
              color: blue500,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data!.firstName} ${data!.lastName}",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "@${data!.username}",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () => PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: FullImage(url: data!.urlPhoto!),
                              withNavBar: false),
                          child: Image.network(
                            data!.urlPhoto != null
                                ? data!.urlPhoto!
                                : "https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/avatar-icon.png?alt=media&token=9927b326-a030-4ee1-97cc-eb66165ec05a&_gl=1*eidyur*_ga*MTYzNTI5NjU5LjE2OTU5MDYwOTI.*_ga_CW55HF8NVT*MTY5OTE5MTU5Ny4zMy4xLjE2OTkxOTE3MTUuOC4wLjA.",
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            width: size.width,
            height: size.height * (2 / 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: shadowMd,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Identitas Diri",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelProfile("Nama Lengkap"),
                        valueProfile("${data!.firstName} ${data!.lastName}")
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelProfile("Username"),
                        valueProfile(data!.username)
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelProfile("Email"),
                        valueProfile(data!.email)
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelProfile("Jenis Kelamin"),
                        valueProfile(data!.jenisKelamin)
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelProfile("Tanggal Lahir"),
                        valueProfile(data!.birthDate)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * (1 / 2) - 32,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed("/edit_profile");
                    },
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * (1 / 2) - 32,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacementNamed('/sign_in');
                    },
                    style: ButtonStyle(
                      side: const MaterialStatePropertyAll(
                        BorderSide(
                          color: slate400,
                          width: 2,
                        ),
                      ),
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Keluar",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: slate500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Text labelProfile(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Poppins",
        fontSize: 14,
        color: Colors.black.withOpacity(0.4),
      ),
    );
  }

  Text valueProfile(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Poppins",
        fontSize: 16,
        color: slate900,
      ),
    );
  }
}
