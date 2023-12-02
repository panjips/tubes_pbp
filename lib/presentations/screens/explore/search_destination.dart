import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/repository/destinasi_respository.dart';
import 'package:test_slicing/utils/constant.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Destinasi>? searchDestinasi;
  TextEditingController search = TextEditingController();

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? searchKeyword = await prefs.getString('id_search');
    List<Destinasi>? dataDestinasi =
        await DestinasiRepositroy().getAllDestinasiFromApi();
    List<Destinasi>? destinasiSearch = dataDestinasi?.where((element) {
      return element.nama!.contains(searchKeyword!);
    }).toList();

    setState(() {
      searchDestinasi = destinasiSearch;
      print(searchDestinasi?.first.nama);
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    // if (searchDestinasi == null) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
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
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        backgroundColor: slate50,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: searchDestinasi == null
          ? const Center(
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
            )
          : Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 24, right: 24),
              child: Column(
                children: [
                  TextFormField(
                    autofocus: false,
                    textAlignVertical: TextAlignVertical.center,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: search,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: slate900,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: "Search destination",
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          saveSearchKeyword(search.text);
                        },
                        icon: const Icon(Icons.search),
                        color: Colors.grey,
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
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ListView.separated(
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  saveIdDestinasi(searchDestinasi![index].id!);

                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed('/detail');
                                },
                                child: SearchDestination(
                                  size: size,
                                  nama: searchDestinasi![index].nama!,
                                  alamat: searchDestinasi![index].alamat!,
                                  linkImage: searchDestinasi![index].image,
                                ),
                              ),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 12,
                              ),
                          itemCount: searchDestinasi!.length),
                    ),
                  )
                ],
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

  saveSearchKeyword(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .setString('id_search', id)
        .then((value) => print("Success set id search $id"))
        .onError((error, stackTrace) => print("Error : $error"));
  }
}

class SearchDestination extends StatelessWidget {
  const SearchDestination({
    super.key,
    required this.size,
    required this.nama,
    required this.alamat,
    this.linkImage,
  });

  final Size size;
  final String nama;
  final String alamat;
  final String? linkImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size.width,
          height: size.height * (1 / 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: linkImage == null
                  ? 'https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/avatar-icon.png?alt=media&token=9927b326-a030-4ee1-97cc-eb66165ec05a&_gl=1*eidyur*_ga*MTYzNTI5NjU5LjE2OTU5MDYwOTI.*_ga_CW55HF8NVT*MTY5OTE5MTU5Ny4zMy4xLjE2OTkxOTE3MTUuOC4wLjA.'
                  : linkImage!,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              httpHeaders: const {
                "Connection": "Keep-Alive",
                "Keep-Alive": "timeout=10, max=10000",
              },
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6),
              child: Text(
                nama,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: slate900,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  FeatherIcons.mapPin,
                  size: 14,
                  color: slate400,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    alamat,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: slate400,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
