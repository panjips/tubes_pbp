import 'dart:convert';

import 'package:http/http.dart';
import 'package:tubes_pbp/data/model/destinasi.dart';

class UlasanRepository {
  static const String url = 'api-pariwisata.my.id';
  // static const String url = '10.0.2.2:8000';
  static const String endpoint = '/api/ulasan';

  Future<List<Ulasan>> getUlasan(String idDestinasi) async {
    var response = await get(Uri.http(url, "$endpoint/$idDestinasi"));
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    final tempAllUlasan = json.decode(response.body)['data'];
    List<Ulasan> ulasan = [];
    for (var element in tempAllUlasan) {
      ulasan.add(Ulasan.fromFirestore(element));
    }
    return ulasan;
  }

  Future<void> tambahUlasan(Ulasan ulasan) async {
    var response = await post(Uri.http(url, endpoint),
        headers: {"Content-Type": "application/json"},
        body: ulasan.toRawJson());
    // print(response.body);
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
  }

  Future<void> deleteUlasan(String idUlasan) async {
    var response = await delete(Uri.http(url, "$endpoint/$idUlasan"));
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
  }

  Future<void> editUlasan(Ulasan newUlasan, String idUlasan) async {
    var response = await put(Uri.http(url, "$endpoint/$idUlasan"),
        headers: {'Content-Type': 'application/json'},
        body: newUlasan.toRawJson());
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    // print(json.decode(response.body));
  }
}
