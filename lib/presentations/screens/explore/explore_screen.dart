import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/repository/destinasi_respository.dart';
import 'package:test_slicing/presentations/widgets/card_destination.dart';
import 'package:test_slicing/utils/constant.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController search = TextEditingController();
  bool isSelected = false;
  List<Destinasi>? allDestinasi;
  String? sortType = 'All';

  void refresh() async {
    List<Destinasi>? dataDestinasi =
        await DestinasiRepositroy().getAllDestinasiFromApi();
    List<Destinasi>? destinasiByType;
    if (sortType != 'All') {
      destinasiByType = dataDestinasi.where((element) {
        return element.kategori == sortType;
      }).toList();
    }

    setState(() {
      if (sortType != 'All') {
        allDestinasi = destinasiByType;
      } else {
        allDestinasi = dataDestinasi;
      }
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (allDestinasi == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed("/search");
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
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose Activity",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: slate900,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, bottom: 12),
              child: SizedBox(
                height: 36,
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          sortType = typeDestination[index];
                          refresh();
                        });
                        print(typeDestination[index]);
                      },
                      child: TypeContainer(
                        type: typeDestination[index],
                        colors: colorType[index],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 8,
                  ),
                  itemCount: typeDestination.length,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: GridView.builder(
                  itemCount: allDestinasi?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        saveIdDestinasi(allDestinasi![index].id!);

                        Navigator.of(context, rootNavigator: true)
                            .pushNamed('/detail');
                      },
                      child: CardDestination(
                        nama: allDestinasi?[index].nama ?? '',
                        alamat: allDestinasi?[index].alamat ?? '',
                        linkImage: allDestinasi![index].image!.isEmpty
                            ? null
                            : allDestinasi![index].image!,
                      ),
                    );
                  },
                ),
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

  List<String> typeDestination = [
    'All',
    'Party',
    'Culinary',
    'Nature',
    'Culture',
    'Adventure',
  ];

  List<MaterialColor> colorType = [
    Colors.cyan,
    Colors.purple,
    Colors.blue,
    Colors.blueGrey,
    Colors.brown,
    Colors.pink,
  ];

  saveSearchKeyword(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .setString('id_search', id)
        .then((value) => print("Success set id search $id"))
        .onError((error, stackTrace) => print("Error : $error"));
  }
}

class TypeContainer extends StatelessWidget {
  const TypeContainer({
    required this.type,
    required this.colors,
    super.key,
  });

  final String type;
  final Color colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          type,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
