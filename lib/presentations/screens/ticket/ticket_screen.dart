import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/model/ticket.dart';
import 'package:test_slicing/data/model/user.dart';
import 'package:test_slicing/data/repository/auth_repository.dart';
import 'package:test_slicing/data/repository/destinasi_respository.dart';
import 'package:test_slicing/data/repository/ticket_repository.dart';
import 'package:test_slicing/presentations/screens/pdf/create_pdf.dart';
import 'package:test_slicing/utils/constant.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<Ticket>? allTicket;
  List<Destinasi> destinasiByTicket = [];
  int? availTicketLength;

  Future<void> getTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = await prefs.getString('id_user');
    // User? userData = await AuthRepository().getUserDetail(idUser!);
    List<Ticket>? ticket = await TicketRepository().showUserTicket(idUser!);
    setState(() {
      // allTicket = userData!.tickets;
      allTicket = ticket;
      print("First Ticket : ${allTicket!.last.idDestinasi}");
      getDestinasi();
    });
  }

  void getDestinasi() async {
    List<Destinasi> all = [];
    for (var element in allTicket!) {
      Destinasi? destinasi =
          await DestinasiRepositroy().getDestinasiFromApi(element.idDestinasi!);
      all.add(destinasi);
    }
    setState(() {
      destinasiByTicket = all;
    });
  }

  @override
  void initState() {
    super.initState();
    getTicket();
  }

  int countExpiredTicket() {
    int sum = 0;
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    allTicket?.forEach((element) {
      if (DateTime.parse(currentDate).millisecondsSinceEpoch <=
          DateTime.parse(element.tanggalTicket!).millisecondsSinceEpoch) {
        sum++;
      }
    });

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (allTicket == null || destinasiByTicket.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("images/empty-ticket.png")),
            SizedBox(
              child: Text(
                "Yah, kamu belum memiliki ticket.",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                  color: slate700,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
            SizedBox(
              child: Text(
                "Tenang, banyak destinasi wisata yang menarik,",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                  color: slate400,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
            SizedBox(
              child: Text(
                "explore sekarang yuk!",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                  color: slate400,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
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
      body: Padding(
        padding: const EdgeInsets.only(right: 24, left: 24, top: 12),
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return TicketContainer(
                size: size,
                destinasi: destinasiByTicket[index],
                ticket: allTicket![index]);
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 12,
          ),
          itemCount: allTicket!.length,
        ),
      ),
    );
  }
}

class TicketContainer extends StatelessWidget {
  const TicketContainer({
    super.key,
    required this.size,
    required this.destinasi,
    required this.ticket,
  });
  final Size size;
  final Destinasi destinasi;
  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: CachedNetworkImage(
                imageUrl: destinasi.image == null
                    ? "https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/destinasi%2Fbanner.png?alt=media&token=44df1d34-7c30-42aa-9e26-385b1a441de4"
                    : destinasi.image!,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                httpHeaders: const {
                  "Connection": "Keep-Alive",
                  "Keep-Alive": "timeout=10, max=10000",
                },
                width: size.width * (1 / 4),
                fit: BoxFit.fill,
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
                    destinasi.nama!,
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
                            "  : ${ticket.tanggalTicket!}",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: slate500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "  : ${ticket.jumlahTicket!}",
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
                    children: [
                      IconButton(
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.only(top: 2),
                        alignment: Alignment.topLeft,
                        onPressed: () {
                          saveIdTicket(ticket.idTicket!);
                          createPdf(context);
                        },
                        icon: Icon(
                          Icons.print,
                          color: blue500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.only(top: 2),
                          alignment: Alignment.topLeft,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text(
                                        "Hapus Ticket",
                                        style: TextStyle(
                                          color: slate900,
                                          fontFamily: "Poppins",
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: const Text(
                                        "Apakah kamu yakin untuk menghapus ticket ini?",
                                        style: TextStyle(
                                          color: slate900,
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Tidak",
                                            style: TextStyle(
                                              color: slate900,
                                              fontFamily: "Poppins",
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "Ya",
                                            style: TextStyle(
                                              color: blue600,
                                              fontFamily: "Poppins",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                          },
                          icon: Icon(
                            Icons.highlight_remove_rounded,
                            color: const Color.fromARGB(255, 162, 24, 15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.only(top: 2),
                          alignment: Alignment.topLeft,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text(
                                        "Reschedule",
                                        style: TextStyle(
                                          color: slate900,
                                          fontFamily: "Poppins",
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: const Text(
                                        "Apakah kamu yakin untuk reschedule ticket ini?",
                                        style: TextStyle(
                                          color: slate900,
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Tidak",
                                            style: TextStyle(
                                              color: slate900,
                                              fontFamily: "Poppins",
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "Ya",
                                            style: TextStyle(
                                              color: blue600,
                                              fontFamily: "Poppins",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                          },
                          icon: Icon(
                            Icons.date_range,
                            color: green600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  saveIdTicket(String id) async {
    final prefs = await SharedPreferences.getInstance();
    print(id);
    await prefs
        .setString('id_ticket', id)
        .then((value) => print("Success set id ticket"))
        .onError((error, stackTrace) => print("Error : $error"));
  }
}
