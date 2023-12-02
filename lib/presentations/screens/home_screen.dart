import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/model/user.dart';
import 'package:test_slicing/data/repository/auth_repository.dart';
import 'package:test_slicing/data/repository/destinasi_respository.dart';
import 'package:test_slicing/presentations/screens/navigation.dart';
import 'package:test_slicing/presentations/widgets/card_destination.dart';
import 'package:test_slicing/presentations/widgets/full_screen_image.dart';
import 'package:test_slicing/presentations/widgets/maps.dart';
import 'package:test_slicing/utils/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? data;
  List<Destinasi>? allDestinasi;

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = await prefs.getString('id_user');
    User? userData = await AuthRepository().showProfile(idUser!);

    List<Destinasi>? dataDestinasi =
        await DestinasiRepositroy().getAllDestinasiFromApi();
    setState(() {
      allDestinasi = dataDestinasi;
      data = userData;
      Future.delayed(Duration(seconds: 5));
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      backgroundColor: slate50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 48, left: 24, right: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back,',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: slate400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${data!.firstName} ${data!.lastName}",
                        style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontFamily: 'Poppins',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: slate900,
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
              ),
              Container(
                margin: const EdgeInsets.only(top: 18),
                width: MediaQuery.of(context).size.width,
                height: 167,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('images/banner.png'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18, bottom: 55),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Where you go next?",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: slate50,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, bottom: 8),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => Navigation(
                                index: 1,
                              ),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: blue500,
                              shadowColor: slate900,
                              elevation: 6,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.3, 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          child: const Text(
                            'Explore now!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: slate50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.topLeft,
                child: const Text(
                  "Trending Destination",
                  style: TextStyle(
                    color: slate900,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (allDestinasi != null)
                SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 5,
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 12,
                    ),
                    itemBuilder: (context, index) {
                      return allDestinasi != null
                          ? GestureDetector(
                              onTap: () {
                                saveIdDestinasi(allDestinasi![index].id!);
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed('/detail');
                              },
                              child: CardDestination(
                                nama: allDestinasi?[index].nama ?? '',
                                alamat: allDestinasi?[index].alamat ?? '',
                                linkImage: allDestinasi![index].image!.isEmpty
                                    ? null
                                    : allDestinasi![index].image!,
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                alignment: Alignment.topLeft,
                child: const Text(
                  "Order Review",
                  style: TextStyle(
                    color: slate900,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Maps(),
            ],
          ),
        ),
      ),
    );
  }

  saveIdDestinasi(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .setString('id_destinasi', id)
        .then((value) => print("Success set id destinasi $id"))
        .onError((error, stackTrace) => print("Error : $error"));
  }
}
