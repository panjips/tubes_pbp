import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tubes_pbp/data/model/destinasi.dart';
import 'package:tubes_pbp/data/model/user.dart';
import 'package:tubes_pbp/data/repository/auth_repository.dart';
import 'package:tubes_pbp/data/repository/ulasan_repository.dart';
import 'package:tubes_pbp/presentations/screens/ulasan/tambah_ulasan_screen.dart';
import 'package:tubes_pbp/utils/constant.dart';

class UlasanScreen extends StatefulWidget {
  const UlasanScreen({super.key});

  @override
  State<UlasanScreen> createState() => _UlasanScreenState();
}

class _UlasanScreenState extends State<UlasanScreen> {
  List<Ulasan> ulasan = [];
  bool isWriteReview = false;

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idDestinasi = prefs.getString('id_destinasi');
    String? idUser = prefs.getString('id_user');
    List<Ulasan>? listUlasan = await UlasanRepository().getUlasan(idDestinasi!);

    bool find =
        listUlasan.any((element) => element.idPengguna == idUser) ?? false;
    setState(() {
      isWriteReview = find;
      ulasan = listUlasan;
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
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: const Icon(
            FeatherIcons.chevronLeft,
            size: 32,
            color: slate900,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true)
              .popAndPushNamed('/detail'),
        ),
        backgroundColor: slate50,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: ulasan.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage("images/empty-ticket.png")),
                  SizedBox(
                    child: Text(
                      "Yah, kamu belum ada review",
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
                      "Kamu sudah pernah kesana?,",
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
                      "review sekarang!",
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
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return UlasanVerticalCard(
                    size: size,
                    ulasan: ulasan[index],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
                itemCount: ulasan.length,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 24, left: 24, bottom: 24),
        child: ElevatedButton(
          onPressed: () {
            if (isWriteReview) {
            } else {
              Navigator.of(context, rootNavigator: true)
                  .pop();
              Navigator.of(context, rootNavigator: true)
                  .push(MaterialPageRoute(builder: (context) => TambahUlasanScreen()));
            }
          },
          style: ButtonStyle(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            enableFeedback: false,
            overlayColor:
                isWriteReview ? null : const MaterialStatePropertyAll(blue600),
            splashFactory: NoSplash.splashFactory,
            backgroundColor:
                MaterialStatePropertyAll(isWriteReview ? slate200 : blue500),
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
            "Write a review",
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
}

class UlasanVerticalCard extends StatefulWidget {
  const UlasanVerticalCard({
    super.key,
    required this.size,
    required this.ulasan,
  });

  final Size size;
  final Ulasan ulasan;
  @override
  State<UlasanVerticalCard> createState() => _UlasanVerticalCardState();
}

class _UlasanVerticalCardState extends State<UlasanVerticalCard> {
  User? userReview;
  String? idLogin;
  String? currentDestinasi;
  final key = GlobalKey();

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = prefs.getString('id_user');
    String? idDestinasi = prefs.getString('id_destinasi');
    User? user = await AuthRepository().showProfile(widget.ulasan.idPengguna!);

    // print(user);
    setState(() {
      idLogin = idUser;
      currentDestinasi = idDestinasi;
      userReview = user;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userReview == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: widget.size.width * 0.6,
          height: widget.size.height * (1 / 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: shadowMd,
          ),
        ),
      );
    }
    return Container(
      width: widget.size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: userReview!.urlPhoto ??
                              'https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/avatar-icon.png?alt=media&token=9927b326-a030-4ee1-97cc-eb66165ec05a&_gl=1*eidyur*_ga*MTYzNTI5NjU5LjE2OTU5MDYwOTI.*_ga_CW55HF8NVT*MTY5OTE5MTU5Ny4zMy4xLjE2OTkxOTE3MTUuOC4wLjA.',
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          httpHeaders: const {
                            "Connection": "Keep-Alive",
                            "Keep-Alive": "timeout=10, max=10000",
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              userReview == null
                                  ? ""
                                  : "${userReview!.firstName} ${userReview!.lastName}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: slate900,
                              ),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 3, left: 6, right: 6, bottom: 3),
                              color: goldStar.withOpacity(0.3),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: goldStar,
                                    size: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      widget.ulasan.rating!,
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: slate900,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                if (idLogin == widget.ulasan.idPengguna)
                  IconButton(
                    key: key,
                    enableFeedback: false,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: const EdgeInsets.only(bottom: 2),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      final RenderBox renderBox =
                          key.currentContext?.findRenderObject() as RenderBox;
                      final Size size = renderBox.size;
                      final Offset offset =
                          renderBox.localToGlobal(Offset.zero);
                      showMenu(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          context: context,
                          useRootNavigator: true,
                          position: RelativeRect.fromLTRB(
                              offset.dx,
                              offset.dy + size.height,
                              offset.dx + size.width,
                              offset.dy + size.height),
                          items: [
                            // _buildPopupMenuItem('Edit'),
                            PopupMenuItem(
                              child: TextButton(
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: slate600,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TambahUlasanScreen(
                                                editData: widget.ulasan),
                                      ));
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: TextButton(
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: slate600,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                onPressed: () async {
                                  await UlasanRepository()
                                      .deleteUlasan(widget.ulasan.id!);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              const UlasanScreen(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                              ),
                            )
                          ]);
                    },
                    icon: const Icon(
                      FeatherIcons.moreVertical,
                      size: 16,
                      color: blue500,
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.ulasan.ulasan!,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: slate600,
                ),
                textAlign: TextAlign.justify,
                overflow: TextOverflow.clip,
              ),
            )
          ],
        ),
      ),
    );
  }
}
