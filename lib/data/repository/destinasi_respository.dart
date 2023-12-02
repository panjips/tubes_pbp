import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'dart:convert';

class DestinasiRepositroy {
  static final String url = '10.0.2.2:8000';
  static final String endpoint = '/api/';

  final dbFirebase = FirebaseFirestore.instance;
  Future<List<Destinasi>> getAllDestinasiFromApi() async {
    var response = await get(Uri.http(url, endpoint));
    print(json.decode(response.body)['data']);
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    final tempAllDestinasi = json.decode(response.body)['data'];
    List<Destinasi> destinasi = [];
    for (var element in tempAllDestinasi) {
      destinasi.add(Destinasi.fromApi(element));
    }

    // print(destinasi.first.image);
    return destinasi;
  }

  Future<Destinasi> getDestinasiFromApi(String idDestinasi) async {
    var response = await get(Uri.http(url, "$endpoint/$idDestinasi"));
    // print(json.decode(response.body)['data']);
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);

    return Destinasi.fromApi(json.decode(response.body)['data']);
  }

  //Firebase Destinasi

  Future<void> addDestinasi(Destinasi destinasi) async {
    final docDestinasi = dbFirebase.collection('destinasi').doc();
    print(docDestinasi.id);
    try {
      destinasi.id = docDestinasi.id;
      await docDestinasi
          .set(destinasi.toJson())
          .then((value) => print('Success'))
          .onError((error, stackTrace) => print("error : $error"));
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<Destinasi?> getDestinasi(String id) async {
    try {
      final snapshot = await dbFirebase
          .collection("destinasi")
          .where("id", isEqualTo: id)
          .get();
      final data = snapshot.docs.map((e) => Destinasi.fromFirestore(e)).single;
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<Destinasi>?>? getAllDestinasi() async {
    try {
      final snapshot = await dbFirebase.collection('destinasi').get();
      if (snapshot.docs.isEmpty) {
        return null;
      }
      print(snapshot.docs.first.data()['ulasan']);
      final dataDestinasi =
          snapshot.docs.map((e) => Destinasi.fromFirestore(e)).toList();
      return dataDestinasi;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

//  static Future<List<Ulasan>> fetchAll() async{
//     try{
//       var response = await get(
//         Uri.http(url, endpoint));

//       if(response.statusCode != 200) throw Exception(response.reasonPhrase);
//       Iterable list = json.decode(response.body)['data'];
//       return list.map((e) => Ulasan.fromJson(e)).toList();  
//     }catch(e){
//       return Future.error(e.toString());
//     }
//   }

  Future<void> addUlasan(String idDestinasi, Ulasan ulasan) async {
    try {
      var response = await post(Uri.http(url, "${endpoint}ulasan/$idDestinasi"),
          headers: {"Content-Type": "application/json"},
          body: ulasan.toRawJson());
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Future<void> addUlasan(String idDestinasi, Ulasan ulasan) async {
  //   await dbFirebase
  //       .collection("destinasi")
  //       .doc(idDestinasi)
  //       .update({
  //         'ulasan': FieldValue.arrayUnion([ulasan.toJson()]),
  //       })
  //       .then((value) => print("Success Tambah"))
  //       .onError((error, stackTrace) => print("error: $error"));
  // }

  Future<void> deleteUlasan(String idDestinasi, Ulasan ulasan) async {
    try {
      var response = await post(Uri.http(url, "${endpoint}ulasan/$idDestinasi"),
          headers: {"Content-Type": "application/json"},
          body: ulasan.toRawJson());
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Future<void> deleteUlasan(String idDestinasi, Ulasan ulasan) async {
  //   await dbFirebase
  //       .collection("destinasi")
  //       .doc(idDestinasi)
  //       .update({
  //         'ulasan': FieldValue.arrayRemove([
  //           {
  //             'idPengguna': ulasan.idPengguna,
  //             'rating': ulasan.rating,
  //             'ulasan': ulasan.ulasan,
  //           }
  //         ]),
  //       })
  //       .then((value) => print("Success Delete"))
  //       .onError((error, stackTrace) => print("error: $error"));
  // }

  Future<void> editUlasan(
    String idDestinasi, Ulasan newUlasan, Ulasan oldUlasan) async {
  try {
    var response = await put(Uri.http(url, '$endpoint/$idDestinasi'), 
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newUlasan.toRawJson()), 
    );

    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
    
  } catch (e) {
      throw Exception(e.toString());
  }
}
  // Future<void> editUlasan(
  //     String idDestinasi, Ulasan newUlasan, Ulasan oldUlasan) async {
  //   await deleteUlasan(idDestinasi, oldUlasan);
  //   await addUlasan(idDestinasi, newUlasan);
  //   //   await dbFirebase
  //   //       .collection("destinasi")
  //   //       .doc(idDestinasi)
  //   //       .update({
  //   //         'ulasan': FieldValue.arrayUnion([
  //   //           {
  //   //             'idPengguna': ulasan.idPengguna,
  //   //             'rating': ulasan.rating,
  //   //             'ulasan': ulasan.ulasan,
  //   //           }
  //   //         ]),
  //   //       })
  //   //       .then((value) => print("Success"))
  //   //       .onError((error, stackTrace) => print("error: $error"));
  // }
}
