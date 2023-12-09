import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:test_slicing/data/model/ticket.dart';

class TicketRepository {
  final dbFirebase = FirebaseFirestore.instance;

  // static const String url = '10.0.2.2:8000';
  static const String url = 'api-pariwisata.my.id';
  static const String endpoint = '/api/ticket';

  Future<void> orderTicketApi(Ticket ticket) async {
    // print(ticket.toApiRawJson());
    var response = await post(Uri.http(url, endpoint),
        headers: {"Content-Type": "application/json"},
        body: ticket.toApiRawJson());
    // print(json.encode(response.body));
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
  }

  Future<Ticket> findTicketApi(String idTicket) async {
    var response = await get(Uri.http(url, "$endpoint/$idTicket"));
    // print(json.encode(response.body));
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);

    return Ticket.fromApi(json.decode(response.body)['data'][0]);
  }

  Future<List<Ticket>> showUserTicket(String idUser) async {
    var response = await get(Uri.http(url, "${endpoint}_all/$idUser"));
    // print(json.encode(response.body));
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    final tempAllTicket = json.decode(response.body)['data'];
    List<Ticket> ticket = [];
    for (var element in tempAllTicket) {
      ticket.add(Ticket.fromApi(element));
    }

    return ticket;
  }

  Future<void> deleteTicket(String idTicket) async {
    var response = await delete(Uri.http(url, "$endpoint/$idTicket"));
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    // print(response.body);
  }

  Future<void> rescheduleTicket(String idTicket, String newTanggal) async {
    var response = await put(Uri.http(url, "$endpoint/$idTicket"), headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "tanggal_ticket": newTanggal,
    });
    // print(response.body);
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
  }

  // Future<void> rescheduleTicket(String idTicket, String newTanggal) async {
  //   try {
  //     var request =
  //         MultipartRequest("POST", Uri.http(url, "$endpoint/$idTicket"));
  //     request.fields['_method'] = "PUT";
  //     request.fields['tanggal_ticket'] = newTanggal;

  //     final response = await request.send();
  //     final responsed = await Response.fromStream(response);

  //     print(responsed.body);
  //     if (response.statusCode != 200) throw Exception(response.reasonPhrase);
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }
}
