// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_pbp/data/model/destinasi.dart';
import 'package:tubes_pbp/data/model/ticket.dart';
import 'package:tubes_pbp/data/repository/destinasi_respository.dart';
import 'package:tubes_pbp/data/repository/ticket_repository.dart';
import 'package:tubes_pbp/presentations/screens/navigation.dart';
import 'package:tubes_pbp/presentations/screens/pdf/create_pdf.dart';
import 'package:tubes_pbp/presentations/widgets/easy_date_timeline_widget/easy_date_timeline_widget.dart';
import 'package:tubes_pbp/presentations/widgets/snackbar.dart';
import 'package:tubes_pbp/properties/day_style.dart';
import 'package:tubes_pbp/properties/easy_day_props.dart';
import 'package:tubes_pbp/properties/easy_header_props.dart';
import 'package:tubes_pbp/utils/constant.dart';

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
    String? idUser = prefs.getString('id_user');
    List<Ticket>? ticket = await TicketRepository().showUserTicket(idUser!);
    setState(() {
      allTicket = ticket;
      log("First Ticket : ${allTicket!.last.idDestinasi}");
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
        title: const Text(
          "Ticket",
          style: TextStyle(
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
            // if (DateTime.parse(allTicket![index].tanggalTicket!)
            //         .millisecondsSinceEpoch >=
            //     DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()))
            //         .millisecondsSinceEpoch) {
            // }
            // return null;
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

class TicketContainer extends StatefulWidget {
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
  State<TicketContainer> createState() => _TicketContainerState();
}

class _TicketContainerState extends State<TicketContainer> {
  String newTanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height * (1 / 7),
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
                imageUrl: widget.destinasi.image == null
                    ? "https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/destinasi%2Fbanner.png?alt=media&token=44df1d34-7c30-42aa-9e26-385b1a441de4"
                    : widget.destinasi.image!,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                httpHeaders: const {
                  "Connection": "Keep-Alive",
                  "Keep-Alive": "timeout=10, max=10000",
                },
                width: widget.size.width * (1 / 4),
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.destinasi.nama!,
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
                            "  : ${widget.ticket.tanggalTicket!}",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: slate500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "  : ${widget.ticket.jumlahTicket!}",
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
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.only(top: 2),
                        alignment: Alignment.topLeft,
                        onPressed: () {
                          saveIdTicket(widget.ticket.idTicket!);
                          createPdf(context);
                        },
                        icon: const Icon(
                          Icons.print,
                          color: blue500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.only(top: 2),
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
                                          onPressed: () async {
                                            await TicketRepository()
                                                .deleteTicket(
                                                    widget.ticket.idTicket!);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              showSnackBar(
                                                  "Success!",
                                                  "Berhasil delete ticket!",
                                                  ContentType.success),
                                            );
                                            Navigator.of(context)
                                                .pushReplacement(
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation1,
                                                        animation2) =>
                                                    const Navigation(
                                                  index: 2,
                                                ),
                                                transitionDuration:
                                                    Duration.zero,
                                                reverseTransitionDuration:
                                                    Duration.zero,
                                              ),
                                            );
                                            // PersistentNavBarNavigator
                                            //     .pushNewScreen(
                                            //   context,
                                            //   screen:
                                            //       const Navigation(index: 2),
                                            //   withNavBar: false,
                                            //   pageTransitionAnimation:
                                            //       PageTransitionAnimation.fade,
                                            // );
                                          },
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
                          icon: const Icon(
                            Icons.highlight_remove_rounded,
                            color: Color.fromARGB(255, 162, 24, 15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.only(top: 2),
                          alignment: Alignment.topLeft,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                  height: widget.size.height * (1 / 3),
                                  width: widget.size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Reschedule Ticket",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: slate600,
                                          ),
                                        ),
                                        EasyDateTimeLine(
                                          initialDate: DateTime.now(),
                                          onDateChange: (selectedDate) {
                                            setState(() {
                                              newTanggal =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(selectedDate);
                                            });
                                          },
                                          activeColor: Colors.blue,
                                          headerProps: const EasyHeaderProps(
                                            padding: EdgeInsets.zero,
                                            selectedDateFormat:
                                                SelectedDateFormat
                                                    .fullDateDMonthAsStrY,
                                            monthPickerType:
                                                MonthPickerType.dropDown,
                                          ),
                                          dayProps: const EasyDayProps(
                                            height: 48.0,
                                            width: 48.0,
                                            dayStructure:
                                                DayStructure.dayStrDayNum,
                                            inactiveDayStyle: DayStyle(
                                              dayNumStyle: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            activeDayStyle: DayStyle(
                                              dayNumStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                if (DateTime.parse(newTanggal)
                                                        .millisecondsSinceEpoch <
                                                    DateTime.parse(DateFormat(
                                                                'yyyy-MM-dd')
                                                            .format(
                                                                DateTime.now()))
                                                        .millisecondsSinceEpoch) {
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(showSnackBar(
                                                          "Error",
                                                          "Tanggal reschedule salah!",
                                                          ContentType.warning));
                                                } else {
                                                  await TicketRepository()
                                                      .rescheduleTicket(
                                                          widget
                                                              .ticket.idTicket!,
                                                          newTanggal);
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation1,
                                                              animation2) =>
                                                          const Navigation(
                                                        index: 2,
                                                      ),
                                                      transitionDuration:
                                                          Duration.zero,
                                                      reverseTransitionDuration:
                                                          Duration.zero,
                                                    ),
                                                  );
                                                  // PersistentNavBarNavigator
                                                  //     .pushNewScreen(
                                                  //   context,
                                                  //   screen: const Navigation(
                                                  //       index: 2),
                                                  //   withNavBar: true,
                                                  //   pageTransitionAnimation:
                                                  //       PageTransitionAnimation
                                                  //           .fade,
                                                  // );
                                                }
                                              },
                                              child: const Text(
                                                "Ubah",
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 16,
                                                    color: green700,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text(
                                                "Batal",
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 16,
                                                    color: slate700,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
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
    await prefs
        .setString('id_ticket', id)
        .then((value) => log("Success set id ticket "))
        .onError((error, stackTrace) => log("Error : $error"));
  }
}
