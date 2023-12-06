import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/repository/ulasan_repository.dart';
import 'package:test_slicing/utils/constant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TambahUlasanScreen extends StatefulWidget {
  const TambahUlasanScreen({super.key, this.editData});

  final Ulasan? editData;
  @override
  State<TambahUlasanScreen> createState() => TambahUlasanScreenState();
}

class TambahUlasanScreenState extends State<TambahUlasanScreen> {
  TextEditingController review = TextEditingController();
  double? rating;

  String? currentDestinasi;
  String? currentUser;

  @override
  void initState() {
    super.initState();
    getId();
    if (widget.editData != null) {
      rating = double.parse(widget.editData!.rating!);
      review.value = TextEditingValue(text: widget.editData!.ulasan!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rating and Review",
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              color: slate900,
              fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            FeatherIcons.chevronLeft,
            size: 32,
            color: slate900,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        backgroundColor: slate50,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rating : ",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  color: slate900,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: RatingBar.builder(
                initialRating: widget.editData == null
                    ? 0
                    : double.parse(widget.editData!.rating!),
                direction: Axis.horizontal,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {

                  setState(() {
                    rating = value;
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                "Review : ",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    color: slate900,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextFormField(
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: slate900,
                ),
                controller: review,
                maxLines: 15,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 24, left: 24, bottom: 24),
        child: ElevatedButton(
          onPressed: () async {
            Ulasan addUlasan = Ulasan(
                idDestinasi: currentDestinasi,
                idPengguna: currentUser,
                rating: rating.toString(),
                ulasan: review.text);
            if (widget.editData == null) {
              // DestinasiRepositroy().addUlasan(currentDestinasi!, addUlasan);
              await UlasanRepository().tambahUlasan(addUlasan);
            } else {
              // await DestinasiRepositroy()
              //     .editUlasan(currentDestinasi!, addUlasan, widget.editData!);
              await UlasanRepository()
                  .editUlasan(addUlasan, widget.editData!.id!);
            }
            // ignore: use_build_context_synchronously
            Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed('/ulasan');
          },
          style: ButtonStyle(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            enableFeedback: false,
            overlayColor: const MaterialStatePropertyAll(blue600),
            splashFactory: NoSplash.splashFactory,
            backgroundColor: const MaterialStatePropertyAll(blue500),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            fixedSize: MaterialStateProperty.all(
              Size(size.width, 48.0),
            ),
          ),
          child: const Text(
            "Post",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ),
    );
  }

  void getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idDestinasi = prefs.getString('id_destinasi');
    String? idUser = prefs.getString('id_user');
    setState(() {
      currentDestinasi = idDestinasi;
      currentUser = idUser;
    });
  }
}
