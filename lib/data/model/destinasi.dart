import 'dart:convert';

class Destinasi {
  String? id;
  String? kategori;
  String? nama;
  String? alamat;
  String? hargaTiketMasuk;
  String? jamOperasional;
  String? deskripsi;
  String? image;
  List<Ulasan>? ulasan;

  Destinasi({
    this.id,
    required this.kategori,
    required this.nama,
    required this.alamat,
    required this.hargaTiketMasuk,
    required this.jamOperasional,
    required this.deskripsi,
    this.image,
    this.ulasan,
  });

  factory Destinasi.fromApi(Map<String, dynamic> data) {
    return Destinasi(
      id: data['id'].toString(),
      nama: data["nama"],
      kategori: data["kategori"],
      alamat: data["alamat"],
      hargaTiketMasuk: data["harga_ticket"],
      jamOperasional: data["jam_operasional"],
      deskripsi: data["deskripsi"],
      image: data['image'],
    );
  }

  @override
  String toString() {
    return '\nDestinasi(id: $id, nama: $nama, alamat: $alamat, hargaTiketMasuk: $hargaTiketMasuk, jamOperasional: $jamOperasional, deskripsi: $deskripsi, image: $image, ulasan: ${ulasan?.map((e) => e.toString())})';
  }
}

class Ulasan {
  String? id;
  String? idDestinasi;
  String? idPengguna;
  String? ulasan;
  String? rating;

  Ulasan({
    this.id,
    this.idDestinasi,
    this.idPengguna,
    this.ulasan,
    this.rating,
  });

  factory Ulasan.fromFirestore(Map<String, dynamic>? data) {
    return Ulasan(
      id: data?['id'].toString(),
      idDestinasi: data?['id_destinasi'].toString(),
      idPengguna: data?['id_user'].toString(),
      ulasan: data?['ulasan'],
      rating: data?['rating'],
    );
  }

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id_destinasi': idDestinasi,
      'id_user': idPengguna,
      'ulasan': ulasan,
      'rating': rating,
    };
  }

  @override
  String toString() {
    return 'Ulasan(id: $id, idDestinasi: $idDestinasi, idPengguna: $idPengguna, ulasan: $ulasan, rating: $rating)';
  }
}
