import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_slicing/data/model/ticket.dart';

class User {
  String? id;
  String email;
  String username;
  String password;
  String firstName;
  String lastName;
  String birthDate;
  String jenisKelamin;
  String? urlPhoto;
  List<Ticket>? tickets;
  User(
      {this.id,
      required this.email,
      required this.username,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.birthDate,
      required this.jenisKelamin,
      this.urlPhoto,
      this.tickets});

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return User(
        id: snapshot.id,
        email: data?["email"],
        username: data?["username"],
        password: data?["password"],
        firstName: data?["firstName"],
        lastName: data?["lastName"],
        birthDate: data?["birthDate"],
        jenisKelamin: data?["jenisKelamin"],
        urlPhoto: data?["urlPhoto"],
        tickets: (data?['tickets'] as List?)
                ?.map((e) => Ticket.fromFirestore(e))
                .toList()
                .cast() ??
            []);
  }

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'jenisKelamin': jenisKelamin,
      'urlPhoto': urlPhoto,
      'tickets': tickets?.map((e) => e.toJson()),
    };
  }

  String toApiRawJson() => json.encode(toApiJson());
  Map<String, dynamic> toApiJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'tanggal_lahir': birthDate,
      'jenis_kelamin': jenisKelamin,
      'urlPhoto': urlPhoto,
      'tickets': tickets?.map((e) => e.toJson()),
    };
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, password: $password, firstName: $firstName, lastName: $lastName, birtDate: $birthDate, jenisKelamin: $jenisKelamin, urlPhoto: $urlPhoto)';
  }
}
