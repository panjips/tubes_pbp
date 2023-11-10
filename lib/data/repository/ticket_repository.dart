import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_slicing/data/model/ticket.dart';

class TicketRepository {
  final dbFirebase = FirebaseFirestore.instance;

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
