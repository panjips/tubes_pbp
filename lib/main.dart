import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pbp/presentations/routes/routes.dart';
import 'package:tubes_pbp/presentations/screens/auth/registrasi_screen.dart';
import 'package:tubes_pbp/presentations/screens/auth/sign_in_screen.dart';
import 'package:tubes_pbp/presentations/screens/auth/sign_up_screen.dart';
import 'package:tubes_pbp/presentations/screens/detail/detail_destinasi_screen.dart';
import 'package:tubes_pbp/presentations/screens/explore/search_destination.dart';
import 'package:tubes_pbp/presentations/screens/home_screen.dart';
import 'package:tubes_pbp/presentations/screens/navigation.dart';
import 'package:tubes_pbp/presentations/screens/order/order_success.dart';
import 'package:tubes_pbp/presentations/screens/order/order_ticket_screen.dart';
import 'package:tubes_pbp/presentations/screens/profile/edit_profile_screen.dart';
import 'package:tubes_pbp/presentations/screens/profile/profile_screen.dart';
import 'package:tubes_pbp/presentations/screens/ulasan/tambah_ulasan_screen.dart';
import 'package:tubes_pbp/presentations/screens/ulasan/ulasan_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.signInScreen,
      routes: {
        Routes.navigation: (context) => const Navigation(),
        Routes.signInScreen: (context) => const SignInScreen(),
        Routes.signUpScreen: (context) => const SignUpScreen(),
        Routes.registrationFormScreen: (context) => const RegistrasiScreen(),
        Routes.homeScreen: (context) => const HomeScreen(),
        Routes.profileScreen: (context) => const ProfileScreen(),
        Routes.editProfileScreen: (context) => const EditProfileScreen(),
        Routes.detailDestinasiScreen: (context) => const DetailScreen(),
        Routes.orderTicketScreen: (context) => const OrderTicketScreen(),
        Routes.searchDestination: (context) => const SearchScreen(),
        Routes.ulasanEachDestination: (context) => const UlasanScreen(),
        Routes.writeUlasan: (context) => const TambahUlasanScreen(),
        Routes.orderSuccess: (context) => const SuccessOrderScreen(),
      },
    );
  }
}