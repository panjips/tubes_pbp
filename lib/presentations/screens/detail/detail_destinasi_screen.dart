import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/model/user.dart';
import 'package:test_slicing/data/repository/auth_repository.dart';
import 'package:test_slicing/data/repository/destinasi_respository.dart';
import 'package:test_slicing/data/repository/ulasan_repository.dart';
import 'package:test_slicing/utils/constant.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Destinasi? showDestinasi;
  List<Ulasan>? listUlasan;
  String? fotoProfile;

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idDestinasi = await prefs.getString('id_destinasi');
    String? profile = prefs.getString('base64profile');
    List<Destinasi>? listDestinasi =
        await DestinasiRepositroy().getAllDestinasiFromApi();
    List<Ulasan>? ulasan = await UlasanRepository().getUlasan(idDestinasi!);
    setState(() {
      fotoProfile = profile;
      listUlasan = ulasan;
      for (var element in listDestinasi!) {
        if (element.id == idDestinasi) {
          showDestinasi = element;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (showDestinasi == null || listUlasan == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Details",
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              color: slate900,
              fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 32,
            color: slate900,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true)
              .pushReplacementNamed('/nav'),
        ),
        backgroundColor: slate50,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: showDestinasi!.image == null
                      ? "https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/destinasi%2Fbanner.png?alt=media&token=44df1d34-7c30-42aa-9e26-385b1a441de4"
                      : showDestinasi!.image!,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  httpHeaders: const {
                    "Connection": "Keep-Alive",
                    "Keep-Alive": "timeout=10, max=10000",
                  },
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 2),
                child: Text(
                  showDestinasi!.nama!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    color: slate900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        FeatherIcons.mapPin,
                        color: slate500,
                        size: 16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: Text(
                          showDestinasi!.alamat!,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: slate400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  showDestinasi!.deskripsi!,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: slate700,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  "Additional Informations",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: slate900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: slate200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      CupertinoIcons.time,
                      color: slate600,
                      size: 28,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Open time",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: slate400,
                        ),
                      ),
                      Text(
                        showDestinasi!.jamOperasional!,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: slate900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: slate200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      CupertinoIcons.money_dollar,
                      color: slate600,
                      size: 34,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Start form",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: slate400,
                        ),
                      ),
                      Text(
                        "Rp. ${showDestinasi!.hargaTiketMasuk!}",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: slate900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Ratings and Reviews",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          color: slate900,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed('/ulasan');
                      },
                      child: const Text(
                        "See more",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: blue600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (listUlasan!.isNotEmpty)
                SizedBox(
                  height: size.height * (1 / 6),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => UlasanCard(
                      size: size,
                      ulasan: listUlasan![index],
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 12,
                    ),
                    itemCount: listUlasan!.length >= 3 ? 3 : 1,
                    scrollDirection: Axis.horizontal,
                  ),
                )
              // UlasanCard(size: size)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 24, left: 24, bottom: 24),
        child: Row(
          children: [
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed("/order");
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  enableFeedback: false,
                  overlayColor: MaterialStatePropertyAll(green700),
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: MaterialStatePropertyAll(green600),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all(
                    Size(size.width * (3 / 4) - 32, 48.0),
                  ),
                ),
                child: Text(
                  "Beli Ticket",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  enableFeedback: false,
                  overlayColor: MaterialStatePropertyAll(blue600),
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: MaterialStatePropertyAll(blue500),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all(
                    Size(size.width * (1 / 4) - 32, 48.0),
                  ),
                ),
                child: Icon(FeatherIcons.map),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UlasanCard extends StatefulWidget {
  const UlasanCard({
    super.key,
    required this.size,
    required this.ulasan,
  });

  final Size size;
  final Ulasan ulasan;

  @override
  State<UlasanCard> createState() => _UlasanCardState();
}

class _UlasanCardState extends State<UlasanCard> {
  User? userReview;

  void refresh() async {
    User? user = await AuthRepository().showProfile(widget.ulasan.idPengguna!);
    setState(() {
      userReview = user;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.white,
        width: widget.size.width * 0.6,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: userReview == null
                            ? 'https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/avatar-icon.png?alt=media&token=9927b326-a030-4ee1-97cc-eb66165ec05a&_gl=1*eidyur*_ga*MTYzNTI5NjU5LjE2OTU5MDYwOTI.*_ga_CW55HF8NVT*MTY5OTE5MTU5Ny4zMy4xLjE2OTkxOTE3MTUuOC4wLjA.'
                            : userReview!.urlPhoto!,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        httpHeaders: const {
                          "Connection": "Keep-Alive",
                          "Keep-Alive": "timeout=10, max=10000",
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            userReview == null
                                ? ""
                                : "${userReview!.firstName} ${userReview!.lastName}",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: slate900,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 3, left: 6, right: 6, bottom: 3),
                            color: goldStar.withOpacity(0.3),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: goldStar,
                                  size: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    widget.ulasan.rating!,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: slate900,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    widget.ulasan.ulasan!,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: slate600,
                    ),
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.fade,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
