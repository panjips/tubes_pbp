import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/model/ticket.dart';
import 'package:test_slicing/data/repository/destinasi_respository.dart';
import 'package:test_slicing/data/repository/ticket_repository.dart';
import 'package:test_slicing/utils/constant.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Destinasi? showDestinasi;

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idDestinasi = await prefs.getString('id_destinasi');
    List<Destinasi>? listDestinasi =
        await DestinasiRepositroy().getAllDestinasi();
    setState(() {
      for (var element in listDestinasi!) {
        if (element.id == idDestinasi) {
          showDestinasi = element;
        }
      }
      print(showDestinasi!.id);
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

    if (showDestinasi == null) {
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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: slate50,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://source.unsplash.com/random/1280x720/?yogyakarta",
                  ),
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
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: slate700,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
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
                      onPressed: () {},
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
              )
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
