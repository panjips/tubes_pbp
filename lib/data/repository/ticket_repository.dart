import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_slicing/data/model/ticket.dart';
import 'package:uuid/uuid.dart';

class TicketRepository {
  final dbFirebase = FirebaseFirestore.instance;

  Future<void> orderTicket(Ticket ticket, String idPengguna) async {
    ticket.idTicket = Uuid().v1();

    await dbFirebase
        .collection("users")
        .doc(idPengguna)
        .update({
          'tickets': FieldValue.arrayUnion([ticket.toJson()]),
        })
        .then((value) => print('Success order ticket'))
        .onError((error, stackTrace) => print('error: $error'));
  }
}
