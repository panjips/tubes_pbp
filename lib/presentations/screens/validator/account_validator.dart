import 'package:tubes_pbp/data/model/user.dart';

bool isUniqueEmail(List<User> users, String input) {
  return users.any((e) => e.email == input);
}

bool isUniqueUsername(List<User> users, String input) {
  return users.any((e) => e.username == input);
}
