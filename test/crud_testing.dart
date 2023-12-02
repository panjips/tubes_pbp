import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_slicing/data/model/ulasan.dart'; // Menggantinya dengan path yang sesuai
import 'package:test_slicing/data/repository/ulasan_repository.dart';

void main() {
  group('UlasanRepository Tests', () {
    test('Dapatkan Ulasan', () async {
      UlasanRepository ulasanRepository = UlasanRepository();
      String idDestinasi = 'id_destinasi_anda';
      List<Ulasan> ulasanList = await ulasanRepository.getUlasan(idDestinasi);

      expect(ulasanList, isNotEmpty);
    });

    test('Tambah Ulasan', () async {
      UlasanRepository ulasanRepository = UlasanRepository();
      Ulasan ulasan = Ulasan(
        id: '1',
        idPengguna: 'pengguna_test',
        ulasan: 'Ini adalah ulasan pengguna untuk destinasi ini.',
      );

      await ulasanRepository.tambahUlasan(ulasan);

      List<Ulasan> ulasanList = await ulasanRepository.getUlasan(ulasan.idDestinasi);
      Ulasan addedUlasan = ulasanList.firstWhere((element) => element.id == ulasan.id, orElse: () => null);

      expect(addedUlasan, isNotNull);
      expect(addedUlasan.idPengguna, ulasan.idPengguna);
      expect(addedUlasan.ulasan, ulasan.ulasan);
    });

    test('Hapus Ulasan', () async {
      UlasanRepository ulasanRepository = UlasanRepository();
      String idUlasan = 'id_ulasan_anda';

      await ulasanRepository.deleteUlasan(idUlasan);
    });

    test('Edit Ulasan', () async {
      UlasanRepository ulasanRepository = UlasanRepository();
      String idUlasan = 'id_ulasan_anda';
      Ulasan newUlasan = Ulasan(
        id: '1',
        idPengguna: 'pengguna_test',
        ulasan: 'Ini adalah ulasan yang diperbarui untuk destinasi ini.',
      );

      await ulasanRepository.editUlasan(newUlasan, idUlasan);
    });
  });
}
