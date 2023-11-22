import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:test_slicing/data/model/user.dart';

class AuthRepository {
  static final String url = '10.0.2.2:8000';
  static final String endpoint = '/api/';

  final dbFirebase = FirebaseFirestore.instance;

  Future<void> registerUser(User user) async {
    try {
      var response = await post(Uri.http(url, "${endpoint}register"),
          headers: {"Content-Type": "application/json"},
          body: user.toApiRawJson());
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<User> loginUser(String username, String password) async {
    var response = await post(Uri.http(url, "${endpoint}login"),
        body: {"username": username, "password": password});

    if (response.statusCode != 200) throw Exception(response.reasonPhrase);

    Map<String, dynamic> dataUser = json.decode(response.body)['data'][0];

    print(dataUser['password']);
    return User(
        id: dataUser['id'].toString(),
        email: dataUser['email'],
        username: dataUser['username'],
        password: dataUser['password'],
        firstName: dataUser['first_name'],
        lastName: dataUser['last_name'],
        birthDate: dataUser['tanggal_lahir'],
        jenisKelamin: dataUser['jenis_kelamin']);
  }

  Future<User> showProfile(String id) async {
    var response = await get(Uri.http(url, "${endpoint}user/$id"));
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    Map<String, dynamic> dataUser = json.decode(response.body)['data'];
    print(dataUser);
    return User(
        id: dataUser['id'].toString(),
        email: dataUser['email'],
        username: dataUser['username'],
        password: dataUser['password'],
        firstName: dataUser['first_name'],
        lastName: dataUser['last_name'],
        birthDate: dataUser['tanggal_lahir'],
        jenisKelamin: dataUser['jenis_kelamin']);
  }

  Future<void> createUser(User user) async {
    final docUser = dbFirebase.collection('users').doc();

    user.id = docUser.id;
    user.urlPhoto = defaultPhotoProfile;
    await docUser.set(user.toJson());
  }

  Future<List<User>> getAllUser() async {
    final snapshot = await dbFirebase.collection("users").get();
    final userData = snapshot.docs.map((e) => User.fromFirestore(e)).toList();
    return userData;
  }

  Future<User?> userLogin(
      {required String username, required String password}) async {
    try {
      final snapshot = await dbFirebase
          .collection("users")
          .where("username", isEqualTo: username)
          .where("password", isEqualTo: password)
          .get();
      final data = snapshot.docs.map((e) => User.fromFirestore(e)).single;
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> getUserDetail(String id) async {
    try {
      final snapshot =
          await dbFirebase.collection("users").where("id", isEqualTo: id).get();
      final data = snapshot.docs.map((e) => User.fromFirestore(e)).single;
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> uploadImage(File imageFile, String email) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("profiles")
        .child("${email}_pic_${DateTime.now().millisecondsSinceEpoch}");
    await storageRef.putFile(
        imageFile, SettableMetadata(contentType: "image/png"));

    return await storageRef.getDownloadURL();
  }

  Future<void> setPhotoProfile(String id, String urlPhoto) async {
    await dbFirebase
        .collection("users")
        .doc(id)
        .update({
          'urlPhoto': urlPhoto,
        })
        .then((value) => print('Success'))
        .onError((error, stackTrace) => print("error : $error"));
  }

  Future<void> editDataUser(User newUser, String id) async {
    await dbFirebase
        .collection("users")
        .doc(id)
        .update({
          'birthDate': newUser.birthDate,
          'email': newUser.email,
          'firstName': newUser.firstName,
          'lastName': newUser.lastName,
          'jenisKelamin': newUser.jenisKelamin,
          'password': newUser.password,
          'username': newUser.username,
        })
        .then((value) => print('Success'))
        .onError((error, stackTrace) => print("error : $error"));
  }

  String defaultPhotoProfile =
      "https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/avatar-icon.png?alt=media&token=9927b326-a030-4ee1-97cc-eb66165ec05a&_gl=1*eidyur*_ga*MTYzNTI5NjU5LjE2OTU5MDYwOTI.*_ga_CW55HF8NVT*MTY5OTE5MTU5Ny4zMy4xLjE2OTkxOTE3MTUuOC4wLjA.";
}
