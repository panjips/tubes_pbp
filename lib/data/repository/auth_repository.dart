import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:test_slicing/data/model/user.dart';

class AuthRepository {
  final dbFirebase = FirebaseFirestore.instance;

  Future<void> createUser(User user) async {
    final docUser = dbFirebase.collection('users').doc();

    user.id = docUser.id;
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
}
