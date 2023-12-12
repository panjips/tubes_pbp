// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tubes_pbp/data/model/destinasi.dart';
import 'package:tubes_pbp/data/model/transport.dart';
import 'package:tubes_pbp/data/repository/destinasi_respository.dart';
import 'package:tubes_pbp/data/repository/transport_repository.dart';
import 'package:tubes_pbp/presentations/screens/navigation.dart';
import 'package:tubes_pbp/presentations/widgets/easy_date_timeline_widget/easy_date_timeline_widget.dart';
import 'package:tubes_pbp/presentations/widgets/snackbar.dart';
import 'package:tubes_pbp/properties/day_style.dart';
import 'package:tubes_pbp/properties/easy_day_props.dart';
import 'package:tubes_pbp/properties/easy_header_props.dart';
import 'package:tubes_pbp/utils/constant.dart';

class Transportasi extends StatefulWidget {
  const Transportasi({super.key});

  @override
  State<Transportasi> createState() => _TransportasiState();
}

class _TransportasiState extends State<Transportasi> {
  List<Transport>? datas;

  void refresh() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idUser = pref.getString("id_user");
    List<Transport>? tempDatas =
        await TransportRepository().showTransport(idUser!);

    setState(() {
      datas = tempDatas;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (datas == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("images/empty-ticket.png")),
            SizedBox(
              child: Text(
                "Yah, kamu belum memiliki pesanan transportasi.",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                  color: slate700,
                ),
                textAlign: TextAlign.center,
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
        title: const Text(
          "Transportasi",
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              color: slate900,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: slate50,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(right: 24, left: 24, top: 12, bottom: 12),
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return TransportContainer(
                size: size,
                data: datas![index],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
            itemCount: datas!.length),
      ),
    );
  }
}

class TransportContainer extends StatefulWidget {
  const TransportContainer({
    super.key,
    required this.size,
    required this.data,
  });

  final Size size;
  final Transport data;

  @override
  State<TransportContainer> createState() => _TransportContainerState();
}

class _TransportContainerState extends State<TransportContainer> {
  Destinasi? showDestinasi;

  void refresh() async {
    Destinasi destinasi = await DestinasiRepositroy()
        .getDestinasiFromApi(widget.data.idDestinasi!);
    setState(() {
      showDestinasi = destinasi;
    });
  }

  TextEditingController tanggal = TextEditingController();
  TextEditingController titikJemput = TextEditingController();
  TextEditingController jenis = TextEditingController();
  List<String> listJenis = [
    'Motor',
    'Mobil',
  ];
  bool isCheck = false;
  String? dropdownValue;
  String harga = "0";

  @override
  void initState() {
    refresh();
    tanggal.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String newTanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (showDestinasi == null) {
      return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: widget.size.width,
            height: widget.size.height * (1 / 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: shadowMd,
            ),
          ));
    }
    return Container(
      width: widget.size.width,
      height: widget.size.height * (1 / 7),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: shadowMd,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transport to ${showDestinasi!.nama}",
            style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                color: slate900,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tanggal ",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: slate600,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Jenis ",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: slate600,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " : ${widget.data.tanggal}",
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: slate600,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    " : ${widget.data.jenis}",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: slate600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Container(
                        height: widget.size.height * (1 / 3.5),
                        width: widget.size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Reschedule Transportasi",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: slate600,
                                ),
                              ),
                              EasyDateTimeLine(
                                initialDate: DateTime.now(),
                                onDateChange: (selectedDate) {
                                  setState(() {
                                    newTanggal = DateFormat('yyyy-MM-dd')
                                        .format(selectedDate);
                                  });
                                },
                                activeColor: Colors.blue,
                                headerProps: const EasyHeaderProps(
                                  padding: EdgeInsets.zero,
                                  selectedDateFormat:
                                      SelectedDateFormat.fullDateDMonthAsStrY,
                                  monthPickerType: MonthPickerType.dropDown,
                                ),
                                dayProps: const EasyDayProps(
                                  height: 48.0,
                                  width: 48.0,
                                  dayStructure: DayStructure.dayStrDayNum,
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      if (DateTime.parse(newTanggal)
                                              .millisecondsSinceEpoch <
                                          DateTime.parse(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.now()))
                                              .millisecondsSinceEpoch) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(showSnackBar(
                                                "Error",
                                                "Tanggal reschedule salah!",
                                                ContentType.warning));
                                      } else {
                                        Transport transport = widget.data;
                                        transport.tanggal = newTanggal;
                                        await TransportRepository()
                                            .updateTransport(transport,
                                                widget.data.idTransport!);
                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          withNavBar: false,
                                          screen: const Navigation(index: 3),
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.fade,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "Ubah",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          color: green700,
                                          fontWeight: FontWeight.w600),
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
                                          fontWeight: FontWeight.w600),
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
                child: const Text(
                  "Edit",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: blue600,
                      fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 12),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  await TransportRepository()
                      .deleteTransport(widget.data.idTransport!);
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    withNavBar: false,
                    screen: const Navigation(index: 3),
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: Color.fromARGB(255, 153, 43, 35),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
