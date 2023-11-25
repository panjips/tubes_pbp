import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/model/ticket.dart';
import 'package:test_slicing/data/repository/destinasi_respository.dart';
import 'package:test_slicing/presentations/widgets/snackbar.dart';
import 'package:test_slicing/utils/constant.dart';
import 'package:test_slicing/data/repository/ticket_repository.dart';
import 'package:test_slicing/easy_date_timeline.dart';
import 'package:uuid/uuid.dart';

class OrderTicketScreen extends StatefulWidget {
  const OrderTicketScreen({super.key});

  @override
  State<OrderTicketScreen> createState() => _OrderTicketScreenState();
}

class _OrderTicketScreenState extends State<OrderTicketScreen> {
  Destinasi? showDestinasi;
  TextEditingController tanggalTicket = TextEditingController();
  TextEditingController jumlahTicket = TextEditingController();
  TextEditingController totalHargaTicket = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idDestinasi = await prefs.getString('id_destinasi');
    List<Destinasi>? listDestinasi =
        await DestinasiRepositroy().getAllDestinasiFromApi();
    // List<Destinasi>? listDestinasi =
    //     await DestinasiRepositroy().getAllDestinasi();
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
    jumlahTicket.text = '0';
    tanggalTicket.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
        centerTitle: true,
        backgroundColor: slate50,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            FeatherIcons.chevronLeft,
            size: 32,
            color: slate900,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Order Ticket",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            color: slate900,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height -
              (kToolbarHeight + MediaQuery.of(context).padding.top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 24, left: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 90,
                            width: 120,
                            child: Image(
                              image: NetworkImage(
                                  "https://source.unsplash.com/random/1280x720/?yogyakarta"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text(
                            showDestinasi!.nama!,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              color: slate900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      height: size.height * (2 / 5),
                      width: size.width,
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            EasyDateTimeLine(
                              initialDate: DateTime.now(),
                              onDateChange: (selectedDate) {
                                setState(() {
                                  tanggalTicket.text = DateFormat('yyyy-MM-dd')
                                      .format(selectedDate);
                                });
                              },
                              activeColor: Colors.blue,
                              headerProps: const EasyHeaderProps(
                                selectedDateFormat:
                                    SelectedDateFormat.fullDateDMonthAsStrY,
                                monthPickerType: MonthPickerType.switcher,
                              ),
                              dayProps: const EasyDayProps(
                                height: 56.0,
                                width: 56.0,
                                dayStructure: DayStructure.dayStrDayNum,
                                inactiveDayStyle: DayStyle(
                                  dayNumStyle: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                activeDayStyle: DayStyle(
                                  dayNumStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Harga Ticket",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            color: slate900,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Rp. ${showDestinasi!.hargaTiketMasuk}",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 20,
                                          color: green600,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (int.parse(jumlahTicket.text) >
                                              0) {
                                            int value =
                                                int.parse(jumlahTicket.text) -
                                                    1;

                                            setState(() {
                                              jumlahTicket.text =
                                                  value.toString();
                                              totalHargaTicket.text = (value *
                                                      (int.parse(showDestinasi!
                                                          .hargaTiketMasuk!)))
                                                  .toString();
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: slate50),
                                          child: Icon(
                                            Icons.exposure_minus_1_rounded,
                                            color: slate500,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 6, right: 6),
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border: Border.all(color: slate500),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            jumlahTicket.text,
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 16,
                                              color: slate400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          int value =
                                              int.parse(jumlahTicket.text) + 1;

                                          setState(() {
                                            jumlahTicket.text =
                                                value.toString();
                                            totalHargaTicket.text = (value *
                                                    (int.parse(showDestinasi!
                                                        .hargaTiketMasuk!)))
                                                .toString();
                                          });
                                        },
                                        child: Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: slate50),
                                          child: Icon(
                                            Icons.plus_one_rounded,
                                            color: slate500,
                                            size: 16,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width,
                height: size.height * (1 / 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: shadowMd,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 24, right: 24, left: 24, bottom: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Harga Total",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: slate900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Rp. ${(int.parse(jumlahTicket.text) * (int.parse(showDestinasi!.hargaTiketMasuk!)))}",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: slate900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (jumlahTicket.text == '0') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  showSnackBar(
                                      "Wrong!",
                                      "Minimal jumlah pembelian ticket adalah 1",
                                      ContentType.failure));
                            } else {
                              final uuid = Uuid().v1();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? idUser = await prefs.getString('id_user');
                              await TicketRepository().orderTicketApi(
                                Ticket(
                                    idTicket: uuid,
                                    idUser: idUser,
                                    idDestinasi: showDestinasi!.id,
                                    jumlahTicket: jumlahTicket.text,
                                    tanggalTicket: tanggalTicket.text,
                                    totalHarga: totalHargaTicket.text),
                              );
                              // await TicketRepository().orderTicket(
                              //     Ticket(
                              //         idTicket: uuid,
                              //         idDestinasi: showDestinasi!.id,
                              //         jumlahTicket: jumlahTicket.text,
                              //         tanggalTicket: tanggalTicket.text,
                              //         totalHarga: totalHargaTicket.text),
                              //     idUser!);
                              // ignore: use_build_context_synchronously
                              saveIdTicket(uuid);
                              Navigator.of(context, rootNavigator: true)
                                  .pushReplacementNamed('/order_success');
                            }
                          },
                          style: ButtonStyle(
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
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
                              Size(size.width - 48, 48.0),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
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
