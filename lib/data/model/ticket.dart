class Ticket {
  String? idDestinasi;
  String? idTicket;
  String? tanggalTicket;
  String? jumlahTicket;
  String? totalHarga;

  Ticket({
    this.idDestinasi,
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

  @override
  String toString() {
    return 'Ticket(idDestinasi: $idDestinasi, idTicket: $idTicket, tanggalTicket: $tanggalTicket, jumlahTicket: $jumlahTicket, totalHarga: $totalHarga)';
  }
}
