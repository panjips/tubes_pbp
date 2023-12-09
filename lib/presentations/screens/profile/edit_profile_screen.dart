import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/user.dart';
import 'package:test_slicing/data/repository/auth_repository.dart';
import 'package:test_slicing/presentations/screens/navigation.dart';
import 'package:test_slicing/presentations/screens/validator/account_validator.dart';
import 'package:test_slicing/presentations/widgets/auth_button.dart';
import 'package:test_slicing/presentations/widgets/input_form.dart';
import 'package:test_slicing/presentations/widgets/snackbar.dart';
import 'package:test_slicing/utils/constant.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController jenisKelamin = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController birthDate = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<User>? allUser;
  User? userLogin;

  bool isPasswordVisible = false;

  void getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = prefs.getString('id_user');

    User? userData = await AuthRepository().showProfile(idUser!);
    setState(() {
      userLogin = userData;
      setValueInput();
    });
  }

  void getAllDataUser() async {
    final dataUsers = await AuthRepository().getAllUserFromApi();
    setState(() {
      allUser = dataUsers;
    });
  }

  List<String> listJenisKelamin = [
    'Laki-Laki',
    'Perempuan',
  ];
  String? dropdownValue;

  void setValueInput() {
    username.text = userLogin!.username;
    password.text = userLogin!.password;
    firstName.text = userLogin!.firstName;
    lastName.text = userLogin!.lastName;
    birthDate.text = userLogin!.birthDate;
    jenisKelamin.text = userLogin!.jenisKelamin;
  }

  @override
  void initState() {
    getAllDataUser();
    getUserLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (userLogin == null || allUser == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: slate50,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        backgroundColor: blue500,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FeatherIcons.chevronLeft),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12, right: 24, left: 24, bottom: 24),
          child: Column(
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: userLogin!.urlPhoto != null
                            ? userLogin!.urlPhoto!
                            : "https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/avatar-icon.png?alt=media&token=9927b326-a030-4ee1-97cc-eb66165ec05a&_gl=1*eidyur*_ga*MTYzNTI5NjU5LjE2OTU5MDYwOTI.*_ga_CW55HF8NVT*MTY5OTE5MTU5Ny4zMy4xLjE2OTkxOTE3MTUuOC4wLjA.",
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              shape: const BeveledRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return bottomSheetEditProfile(size);
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.blue,
                          )),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    labelInput(text: "Username", bottom: 4.0, top: 4.0),
                    inputForm((value) {
                      if (value == null || value.isEmpty) {
                        return 'Username tidak boleh kosong!';
                      }
                      if (isUniqueUsername(allUser!, value)) {
                        if (value == userLogin!.username) {
                          return null;
                        }
                        return 'Username telah digunakan!';
                      }
                      return null;
                    }, controller: username, hintText: "example"),
                    labelInput(text: "Password", bottom: 4.0, top: 4.0),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong!";
                        } else if (value.length < 6) {
                          return "Password harus memiliki setidaknya 6 karakter!";
                        }
                        return null;
                      },
                      obscureText: !isPasswordVisible,
                      textAlignVertical: TextAlignVertical.center,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: password,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: slate900,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        hintText: "•••••••",
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
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: isPasswordVisible ? Colors.blue : Colors.grey,
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
                    labelInput(text: "Nama Depan", bottom: 4.0, top: 4.0),
                    inputForm((value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Depan tidak boleh kosong!';
                      }
                    }, controller: firstName, hintText: "Alex"),
                    labelInput(text: "Nama Belakang", bottom: 4.0, top: 4.0),
                    inputForm((value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Belakang tidak boleh kosong!';
                      }
                    }, controller: lastName, hintText: "Gilbert"),
                    labelInput(text: "Tanggal Lahir", bottom: 4.0, top: 4.0),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal Lahir Tidak Boleh Kosong';
                        }
                        try {
                          DateTime selectedDate = DateTime.parse(value);
                          int year = selectedDate.year;
                          if (year < 1970 || year > 2023) {
                            return 'Tahun lahir harus antara 1970 dan 2023';
                          }
                        } catch (error) {
                          return 'Format tanggal tidak valid';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlignVertical: TextAlignVertical.center,
                      controller: birthDate,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: slate900,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        hintText: "2003-12-02",
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
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  1900), // Set an appropriate minimum date
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                birthDate.text = formattedDate;
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_month_rounded),
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
                    labelInput(text: "Jenis Kelamin", bottom: 4.0, top: 4.0),
                    DropdownButtonFormField2(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jenis kelamin tidak boleh kosong!';
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
                        hintText: "Pilih Jenis Kelamin",
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
                      value: jenisKelamin.text,
                      items: listJenisKelamin
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          jenisKelamin.text = value!;
                        });
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 24, left: 24, bottom: 24),
        child: AuthButton(() async {
          if (_formKey.currentState!.validate()) {
            User user = User(
                email: userLogin!.email,
                username: username.text,
                password: password.text,
                firstName: firstName.text,
                lastName: lastName.text,
                birthDate: birthDate.text,
                jenisKelamin: jenisKelamin.text);
            await AuthRepository().editProfileUser(user, userLogin!.id!);
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
                "Success!", "Berhasil edit profile!", ContentType.success));
            // ignore: use_build_context_synchronously
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: const Navigation(index: 4),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          }
        }, size: size, text: "Save Edit"),
      ),
    );
  }

  Container bottomSheetEditProfile(Size size) {
    return Container(
      width: size.width,
      height: size.height * 1 / 5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            height: 4,
            width: size.width * 1 / 6,
            decoration: BoxDecoration(
              color: slate400,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Photo Profile",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: slate900,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            margin: const EdgeInsets.only(bottom: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: slate500,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                File image = await _pickImageFromCamera();
                                await AuthRepository().editPhotoProfile(
                                    userLogin!, userLogin!.id!, image);
                                setState(() {
                                  getUserLogin();
                                });
                              },
                              icon: const Icon(Icons.camera_alt),
                              color: slate500,
                            ),
                          ),
                          const Text(
                            "Camera",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: slate500,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Column(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            margin: const EdgeInsets.only(bottom: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: slate500,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                File image = await _pickImageFromGallery();
                                await AuthRepository().editPhotoProfile(
                                    userLogin!, userLogin!.id!, image);
                                setState(() {
                                  getUserLogin();
                                });
                              },
                              icon: const Icon(
                                  Icons.photo_size_select_actual_rounded),
                              color: slate500,
                            ),
                          ),
                          const Text(
                            "Galery",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: slate500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future _pickImageFromCamera() async {
  final returnedImage = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 25);

  if (returnedImage == null) return;
  final imageFile = File(returnedImage.path);

  return imageFile;
}

Future _pickImageFromGallery() async {
  final returnedImage = await ImagePicker()
      .pickImage(source: ImageSource.gallery, imageQuality: 25);

  if (returnedImage == null) return;
  final imageFile = File(returnedImage.path);

  return imageFile;
}
