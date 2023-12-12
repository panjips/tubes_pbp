import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Transport {
  String? idTransport;
  String? idDestinasi;
  String? idUser;
  String? titikJemput;
  String? tanggal;
  String? jenis;
  String? harga;

  Transport({
    this.idTransport,
    this.idDestinasi,
    this.idUser,
    this.titikJemput,
    this.tanggal,
    this.jenis,
    this.harga,
  });

  String toApiRawJson() => json.encode(toApiJson());
  Map<String, dynamic> toApiJson() {
    return <String, dynamic>{
      'id_user': idUser,
      'id_destinasi': idDestinasi,
      'titik_jemput': titikJemput,
      'tanggal': tanggal,
      'jenis': jenis,
      'harga': harga,
    };
  }

  factory Transport.fromApi(Map<String, dynamic>? data) {
    return Transport(
      idTransport: data?['id'].toString(),
      idDestinasi: data?['id_destinasi'].toString(),
      idUser: data?['id_user'].toString(),
      titikJemput: data?['titik_jemput'],
      tanggal: data?['tanggal'],
      jenis: data?['jenis'],
      harga: data?['harga'],
    );
  }

  @override
  String toString() {
    return 'Transport(idTransport: $idTransport, idDestinasi: $idDestinasi, idUser: $idUser, titikJemput: $titikJemput, tanggal: $tanggal, jenis: $jenis, harga: $harga)';
  }
}
