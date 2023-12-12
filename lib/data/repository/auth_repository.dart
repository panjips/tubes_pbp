import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:tubes_pbp/data/model/user.dart';
import 'package:http_parser/http_parser.dart';

class AuthRepository {
  static const String url = 'api-pariwisata.my.id';
  static const String endpoint = '/api/';


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

  Future<User?> loginUser(String username, String password) async {
    try {
      var response = await post(Uri.http(url, "${endpoint}login"), headers: {
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000",
      }, body: {
        "username": username,
        "password": password
      });
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Map<String, dynamic> dataUser = json.decode(response.body)['data'];
      return User(
          id: dataUser['id'].toString(),
          email: dataUser['email'],
          username: dataUser['username'],
          password: dataUser['password'],
          firstName: dataUser['first_name'],
          lastName: dataUser['last_name'],
          birthDate: dataUser['tanggal_lahir'],
          jenisKelamin: dataUser['jenis_kelamin'],
          urlPhoto: dataUser['image']);
    } catch (e) {
      return null;
    }
  }

  Future<User> showProfile(String id) async {
    var response = await get(Uri.http(url, "${endpoint}user/$id"), headers: {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=1000",
    });
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);

    Map<String, dynamic> dataUser = json.decode(response.body)['data'];
    return User(
        id: dataUser['id'].toString(),
        email: dataUser['email'],
        username: dataUser['username'],
        password: dataUser['password'],
        firstName: dataUser['first_name'],
        lastName: dataUser['last_name'],
        birthDate: dataUser['tanggal_lahir'],
        jenisKelamin: dataUser['jenis_kelamin'],
        urlPhoto: dataUser['image']);
  }

  Future<void> editProfileUser(User user, String id) async {
    try {
      var response = await put(Uri.http(url, "${endpoint}user/$id"),
          headers: {
            "Connection": "Keep-Alive",
            "Keep-Alive": "timeout=5, max=1000",
            'Content-Type': 'application/json'
          },
          body: user.toApiRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Future<void> editProfileUser(User user, String id) async {
  //   try {
  //     var request =
  //         MultipartRequest("POST", Uri.http(url, "${endpoint}user/$id"));
  //     request.fields['_method'] = "PUT";
  //     request.fields['id'] = id;
  //     request.fields['email'] = user.email;
  //     request.fields['username'] = user.username;
  //     request.fields['password'] = user.password;
  //     request.fields['first_name'] = user.firstName;
  //     request.fields['last_name'] = user.lastName;
  //     request.fields['tanggal_lahir'] = user.birthDate;
  //     request.fields['jenis_kelamin'] = user.jenisKelamin;

  //     final response = await request.send();
  //     final responsed = await Response.fromStream(response);

  //     // print(responsed.body);
  //     if (response.statusCode != 200) throw Exception(response.reasonPhrase);
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  Future<void> editPhotoProfile(User user, String id, File image) async {
    try {
      log(id);
      var request =
          MultipartRequest("POST", Uri.http(url, "${endpoint}user/photo/$id"));
      request.fields['_method'] = "PUT";
      request.files.add(
        await MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpg'),
        ),
      );

      final response = await request.send();
      final responsed = await Response.fromStream(response);

      if (responsed.statusCode != 200) throw Exception(response.reasonPhrase);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List<User>> getAllUserFromApi() async {
    var response = await get(Uri.http(url, "${endpoint}user"));
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    final tempAllUser = (json.decode(response.body)['data']);
    List<User> user = [];
    for (var element in tempAllUser) {
      user.add(User.fromApi(element));
    }
    return user;
  }

  String defaultPhotoProfile =
      "https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/avatar-icon.png?alt=media&token=9927b326-a030-4ee1-97cc-eb66165ec05a&_gl=1*eidyur*_ga*MTYzNTI5NjU5LjE2OTU5MDYwOTI.*_ga_CW55HF8NVT*MTY5OTE5MTU5Ny4zMy4xLjE2OTkxOTE3MTUuOC4wLjA.";
}
