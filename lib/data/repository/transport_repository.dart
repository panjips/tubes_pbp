import 'dart:convert';

import 'package:http/http.dart';
import 'package:tubes_pbp/data/model/transport.dart';

class TransportRepository {
  static const String url = 'api-pariwisata.my.id';
  // static const String url = '10.0.2.2:8000';
  static const String endpoint = '/api/transport';

  Future<void> addTransport(Transport transport) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: transport.toApiRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List<Transport>?> showTransport(String idUser) async {
    try {
      var response = await get(Uri.http(url, "$endpoint/$idUser"));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      final tempDatas = json.decode(response.body)['data'];

      List<Transport>? transportasi = [];
      for (var element in tempDatas) {
        transportasi.add(Transport.fromApi(element));
      }
      if (transportasi.isEmpty) {
        return null;
      }
      return transportasi;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> updateTransport(Transport transport, String idTransport) async {
    try {
      var response = await put(Uri.http(url, "$endpoint/$idTransport"),
          headers: {
            "Connection": "Keep-Alive",
            "Keep-Alive": "timeout=5, max=1000",
            'Content-Type': 'application/json'
          },
          body: transport.toApiRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> deleteTransport(String idTransport) async {
    try {
      var response = await delete(Uri.http(url, "$endpoint/$idTransport"));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    } catch (e) {
      return Future.error(e.toString());
    }
    // print(response.body);
  }
}
