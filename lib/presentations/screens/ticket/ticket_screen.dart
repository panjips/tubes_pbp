import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/model/ticket.dart';
import 'package:test_slicing/data/model/user.dart';
import 'package:test_slicing/data/repository/auth_repository.dart';
import 'package:test_slicing/data/repository/destinasi_respository.dart';
import 'package:test_slicing/utils/constant.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<Ticket>? allTicket;
  List<Destinasi>? allDestinasi;
  List<Destinasi> destinasiByTicket = [];

  Future<void> getTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = await prefs.getString('id_user');
    User? userData = await AuthRepository().getUserDetail(idUser!);
    setState(() {
      allTicket = userData?.tickets;
      print("First Ticket : ${allTicket!.last.idDestinasi}");
      getDestinasi();
    });
  }

  void getDestinasi() async {
    for (var element in allTicket!) {
      Destinasi? destinasi =
          await DestinasiRepositroy().getDestinasi(element.idDestinasi!);
      setState(() {
        print(destinasi?.id);
        destinasiByTicket.add(destinasi!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTicket();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (destinasiByTicket.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Ticket",
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: slate900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 24, left: 24, top: 4),
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * (1 / 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: slate300),
                boxShadow: shadowMd,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image(
                        width: size.width * (1 / 4),
                        image: NetworkImage(destinasiByTicket.isEmpty
                            ? 'https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/avatar-icon.png?alt=media&token=9927b326-a030-4ee1-97cc-eb66165ec05a&_gl=1*eidyur*_ga*MTYzNTI5NjU5LjE2OTU5MDYwOTI.*_ga_CW55HF8NVT*MTY5OTE5MTU5Ny4zMy4xLjE2OTkxOTE3MTUuOC4wLjA.'
                            : destinasiByTicket.first.image!.first),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destinasiByTicket.first.nama!,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: slate900,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanggal Ticket",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: slate500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Jumlah Ticket",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: slate500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "  : ${allTicket!.first.tanggalTicket!}",
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: slate500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "  : ${allTicket!.first.jumlahTicket!}",
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: slate500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.only(top: 2),
                                alignment: Alignment.topLeft,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.info_outline_rounded,
                                  color: green600,
                                ),
                              ),
                              IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.only(top: 2, left: 8),
                                alignment: Alignment.topLeft,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.print,
                                  color: blue500,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
