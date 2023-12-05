import 'dart:convert';
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

  factory User.fromApi(Map<String, dynamic> data) {
    return User(
      id: data['id'].toString(),
      email: data["email"],
      username: data["username"],
      password: data["password"],
      firstName: data["first_name"],
      lastName: data["last_name"],
      birthDate: data["tanggal_lahir"],
      jenisKelamin: data["jenis_kelamin"],
      urlPhoto: data["image"],
    );
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
      // 'image': null,
      // 'tickets': tickets?.map((e) => e.toJson()),
    };
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, password: $password, firstName: $firstName, lastName: $lastName, birtDate: $birthDate, jenisKelamin: $jenisKelamin, urlPhoto: $urlPhoto)';
  }
}
