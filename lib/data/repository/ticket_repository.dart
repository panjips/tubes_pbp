import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:test_slicing/data/model/ticket.dart';

class TicketRepository {
  final dbFirebase = FirebaseFirestore.instance;

  static final String url = '10.0.2.2:8000';
  static final String endpoint = '/api/ticket';

  Future<void> orderTicketApi(Ticket ticket) async {
    // print(ticket.toApiRawJson());
    var response = await post(Uri.http(url, endpoint),
        headers: {"Content-Type": "application/json"},
        body: ticket.toApiRawJson());
    // print(json.encode(response.body));
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);

    print(response);
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

  //Fireabase repository

  Future<void> orderTicket(Ticket ticket, String idPengguna) async {
    await dbFirebase
        .collection("users")
        .doc(idPengguna)
        .update({
          'tickets': FieldValue.arrayUnion([ticket.toJson()]),
        })
        .then((value) => print('Success order ticket'))
        .onError((error, stackTrace) => print('error: $error'));
  }

  Future<Ticket> findTicket(String idPengguna, String idTicket) async {
    Ticket? dataTicket;
    final data = await dbFirebase
        .collection("users")
        .doc(idPengguna)
        .get()
        .then((value) {
      return value.get("tickets");
    });

    for (var element in data) {
      if (element["idTicket"] == idTicket) {
        final get = Ticket.fromFirestore(element);
        dataTicket = get;
      }
    }

    return dataTicket!;
  }
}
