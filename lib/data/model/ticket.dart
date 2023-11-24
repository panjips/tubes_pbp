// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Ticket {
  String? idUser;
  String? idDestinasi;
  String? idTicket;
  String? tanggalTicket;
  String? jumlahTicket;
  String? totalHarga;

  Ticket({
    this.idDestinasi,
    this.idUser,
    this.idTicket,
    this.tanggalTicket,
    this.jumlahTicket,
    this.totalHarga,
  });

  factory Ticket.fromFirestore(Map<String, dynamic>? data) {
    return Ticket(
      idDestinasi: data?['idDestinasi'],
      idTicket: data?['idTicket'],
      tanggalTicket: data?['tanggalTicket'],
      jumlahTicket: data?['jumlahTicket'],
      totalHarga: data?['totalHarga'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDestinasi': idDestinasi,
      'idTicket': idTicket,
      'tanggalTicket': tanggalTicket,
      'jumlahTicket': jumlahTicket,
      'totalHarga': totalHarga,
    };
  }

  factory Ticket.fromApi(Map<String, dynamic>? data) {
    return Ticket(
      idUser: data?['id_user'].toString(),
      idDestinasi: data?['id_destinasi'].toString(),
      idTicket: data?['id_ticket'],
      tanggalTicket: data?['tanggal_ticket'],
      jumlahTicket: data?['jumlah_ticket'].toString(),
      totalHarga: data?['total_harga'],
    );
  }

  String toApiRawJson() => json.encode(toApiJson());
  Map<String, dynamic> toApiJson() {
    return <String, dynamic>{
      'id_user': idUser,
      'id_destinasi': idDestinasi,
      'id_ticket': idTicket,
      'tanggal_ticket': tanggalTicket,
      'jumlah_ticket': jumlahTicket,
      'total_harga': totalHarga,
    };
  }

  @override
  String toString() {
    return 'Ticket(idUser: $idUser, idDestinasi: $idDestinasi, idTicket: $idTicket, tanggalTicket: $tanggalTicket, jumlahTicket: $jumlahTicket, totalHarga: $totalHarga)';
  }
}
