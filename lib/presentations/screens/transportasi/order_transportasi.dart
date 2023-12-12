import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_pbp/data/model/destinasi.dart';
import 'package:tubes_pbp/data/model/transport.dart';
import 'package:tubes_pbp/data/repository/destinasi_respository.dart';
import 'package:tubes_pbp/presentations/screens/transportasi/order_transportasi_success.dart';
import 'package:tubes_pbp/presentations/widgets/easy_date_timeline_widget/easy_date_timeline_widget.dart';
import 'package:tubes_pbp/presentations/widgets/snackbar.dart';
import 'package:tubes_pbp/properties/day_style.dart';
import 'package:tubes_pbp/properties/easy_day_props.dart';
import 'package:tubes_pbp/properties/easy_header_props.dart';
import 'package:tubes_pbp/utils/constant.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tubes_pbp/data/repository/transport_repository.dart';

class OrderTransportasi extends StatefulWidget {
  const OrderTransportasi({super.key, this.isBuyTicket});

  final bool? isBuyTicket;

  @override
  State<OrderTransportasi> createState() => _OrderTransportasiState();
}

class _OrderTransportasiState extends State<OrderTransportasi> {
  Destinasi? showDestinasi;
  TextEditingController tanggal = TextEditingController();
  TextEditingController titikJemput = TextEditingController();
  TextEditingController jenis = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> listJenis = [
    'Motor',
    'Mobil',
  ];
  String harga = "0";
  String? dropdownValue;
  double? latitude;
  double? longitude;
  bool isCheck = false;

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? latitudePref = prefs.getString('latitude');
    String? longitudePref = prefs.getString('longitude');
    String? idDestinasi = prefs.getString('id_destinasi');
    List<Destinasi>? listDestinasi =
        await DestinasiRepositroy().getAllDestinasiFromApi();
    setState(() {
      for (var element in listDestinasi) {
        if (element.id == idDestinasi) {
          showDestinasi = element;
        }
      }
      latitude = double.parse(latitudePref!);
      longitude = double.parse(longitudePref!);
    });
  }

  @override
  void initState() {
    refresh();
    tanggal.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
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
          "Order Transportasi",
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              color: slate900,
              fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            FeatherIcons.x,
            size: 32,
            color: slate900,
          ),
          onPressed: () {
            if (widget.isBuyTicket!) {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed('/order_success');
            } else {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed('/nav');
            }
          },
        ),
        backgroundColor: slate50,
        elevation: 0.0,
        centerTitle: true,
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
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 90,
                              width: 120,
                              child: Image(
                                image: CachedNetworkImageProvider(showDestinasi!
                                            .image !=
                                        null
                                    ? showDestinasi!.image!
                                    : "https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/destinasi%2Fbanner.png?alt=media&token=44df1d34-7c30-42aa-9e26-385b1a441de4"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            showDestinasi!.nama!,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
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
                            EasyDateTimeLine(
                              initialDate: DateTime.now(),
                              onDateChange: (selectedDate) {
                                setState(() {
                                  tanggal.text = DateFormat('yyyy-MM-dd')
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
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                "Jenis Transportasi",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: slate600,
                                ),
                              ),
                            ),
                            DropdownButtonFormField2(
                              key: const Key("jenis"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Jenis kendaraan tidak boleh kosong!';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                color: slate900,
                              ),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                hintText: "Pilih Jenis Transportasi",
                                errorStyle: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                                hintStyle: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: slate400,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: slate300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              // value: dropdownValue,
                              items: listJenis
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  jenis.text = value!;
                                  dropdownValue = value;
                                  if (dropdownValue == "Mobil") {
                                    harga = "30000";
                                  } else {
                                    harga = "20000";
                                  }
                                  isCheck = false;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Titik Jemput",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: slate600,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      List<Placemark> placemarks =
                                          await placemarkFromCoordinates(
                                              latitude!, longitude!);
                                      setState(() {
                                        titikJemput.text =
                                            placemarks.first.street!;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      "Use Current Loc.",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: green700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              key: const Key("TitikJemput"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Titik jemput tidak boleh kosong!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textAlignVertical: TextAlignVertical.center,
                              controller: titikJemput,
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                color: slate900,
                              ),
                              decoration: InputDecoration(
                                suffix: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      if (!isCheck) {
                                        String newHarga;
                                        if (dropdownValue == "Mobil") {
                                          newHarga =
                                              (int.parse(harga) * 3).toString();
                                        } else {
                                          newHarga =
                                              (int.parse(harga) * 2).toString();
                                        }
                                        setState(() {
                                          harga = newHarga;
                                          isCheck = true;
                                        });
                                      }
                                    },
                                    child: const Text(
                                      "Check",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        color: blue500,
                                      ),
                                    )),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                hintText: "Isi Titik Penjemputan",
                                hintStyle: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: slate400,
                                ),
                                errorStyle: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: slate300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
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
                  borderRadius: const BorderRadius.only(
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
                            "Rp. $harga",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: slate900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (isCheck) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            String? idDestinasi =
                                prefs.getString('id_destinasi');
                            String? idUser = prefs.getString('id_user');
                            Transport transport = Transport(
                                harga: harga,
                                idDestinasi: idDestinasi,
                                idUser: idUser,
                                jenis: jenis.text,
                                tanggal: tanggal.text,
                                titikJemput: titikJemput.text);
                            await TransportRepository().addTransport(transport);
                            // ignore: use_build_context_synchronously
                            // Navigator.of(context)
                            //     .pushReplacementNamed(
                            //         '/order_transportasi_success');
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TransportasiSuccessOrderScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                showSnackBar(
                                    "Wrong!",
                                    "Silahkan check lokasi terlebih dahulu!",
                                    ContentType.failure));
                          }
                        },
                        style: ButtonStyle(
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          enableFeedback: false,
                          overlayColor:
                              const MaterialStatePropertyAll(green700),
                          splashFactory: NoSplash.splashFactory,
                          backgroundColor:
                              const MaterialStatePropertyAll(green600),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          fixedSize: MaterialStateProperty.all(
                            Size(size.width - 48, 48.0),
                          ),
                        ),
                        child: const Text(
                          "Pesan Transport",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
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
}
