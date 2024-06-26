import 'dart:convert';

import 'package:http/http.dart';
import 'package:tubes_pbp/data/model/destinasi.dart';

class DestinasiRepositroy {
  static const String url = 'api-pariwisata.my.id';
  // static const String url = '10.0.2.2:8000';
  static const String endpoint = '/api/destinasi';

  Future<List<Destinasi>> getAllDestinasiFromApi() async {
    var response = await get(
      Uri.http(url, endpoint),
      headers: {
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000",
      },
    );
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    final tempAllDestinasi = json.decode(response.body)['data'];
    List<Destinasi> destinasi = [];
    for (var element in tempAllDestinasi) {
      destinasi.add(Destinasi.fromApi(element));
    }
    return destinasi;
  }

  Future<Destinasi> getDestinasiFromApi(String idDestinasi) async {
    var response = await get(Uri.http(url, "$endpoint/$idDestinasi"));
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);

    return Destinasi.fromApi(json.decode(response.body)['data']);
  }
}
