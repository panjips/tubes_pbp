import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:test_slicing/data/model/user.dart';
import 'package:test_slicing/data/repository/auth_repository.dart';
import 'package:test_slicing/presentations/screens/auth/sign_in_screen.dart';
import 'package:test_slicing/presentations/screens/validator/account_validator.dart';
import 'package:test_slicing/presentations/widgets/auth_button.dart';
import 'package:test_slicing/presentations/widgets/input_form.dart';
import 'package:test_slicing/presentations/widgets/snackbar.dart';
import 'package:test_slicing/utils/constant.dart';
import 'package:intl/intl.dart';

class RegistrasiScreen extends StatefulWidget {
  const RegistrasiScreen({super.key});

  @override
  State<RegistrasiScreen> createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController jenisKelamin = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  List<User>? allUser;

  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  List<String> listJenisKelamin = [
    'Laki-Laki',
    'Perempuan',
  ];
  String? dropdownValue;

  void refresh() async {
    final dataUsers = await AuthRepository().getAllUserFromApi();
    setState(() {
      allUser = dataUsers;
    });
  }

  @override
  void initState() {
    refresh();
    dropdownValue = listJenisKelamin.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          "Registrasi",
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
        padding: const EdgeInsets.only(bottom: 64),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12, right: 24, left: 24, bottom: 24),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelInput(text: "Email", bottom: 4.0),
                    inputForm((value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Email harus menggunakan @';
                      }
                      if (isUniqueEmail(allUser ?? [], value)) {
                        return 'Email telah digunakan!';
                      }
                      return null;
                    }, controller: email, hintText: "example@gmail.com"),
                    labelInput(text: "Username", bottom: 4.0, top: 4.0),
                    inputForm((value) {
                      if (value == null || value.isEmpty) {
                        return 'Username tidak boleh kosong!';
                      }
                      if (isUniqueUsername(allUser ?? [], value)) {
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
                      // value: dropdownValue,
                      items: listJenisKelamin
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          jenisKelamin.text = value!;
                          dropdownValue = value;
                        });
                      },
                    )
                  ],
                ),
              ),
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
                email: email.text,
                username: username.text,
                password: password.text,
                firstName: firstName.text,
                lastName: lastName.text,
                birthDate: birthDate.text,
                jenisKelamin: jenisKelamin.text);

            // await AuthRepository().createUser(user);
            await AuthRepository().registerUser(user);
            ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Success!",
                "Berhasil registrasi, masuk sekarang!", ContentType.success));
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ));
          }
        }, size: size, text: "Sign up"),
      ),
    );
  }
}
