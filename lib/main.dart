import 'package:flutter/material.dart';
import 'package:test_slicing/presentations/routes/routes.dart';
import 'package:test_slicing/presentations/screens/auth/registrasi_screen.dart';
import 'package:test_slicing/presentations/screens/auth/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_slicing/presentations/screens/auth/sign_up_screen.dart';
import 'package:test_slicing/presentations/screens/detail/detail_destinasi_screen.dart';
import 'package:test_slicing/presentations/screens/explore/search_destination.dart';
import 'package:test_slicing/presentations/screens/home_screen.dart';
import 'package:test_slicing/presentations/screens/navigation.dart';
import 'package:test_slicing/presentations/screens/order/order_success.dart';
import 'package:test_slicing/presentations/screens/order/order_ticket_screen.dart';
import 'package:test_slicing/presentations/screens/profile/edit_profile_screen.dart';
import 'package:test_slicing/presentations/screens/profile/profile_screen.dart';
import 'package:test_slicing/presentations/screens/transportasi/order_transportasi.dart';
import 'package:test_slicing/presentations/screens/transportasi/order_transportasi_success.dart';
import 'package:test_slicing/presentations/screens/transportasi/transportasi_screen.dart';
import 'package:test_slicing/presentations/screens/ulasan/tambah_ulasan_screen.dart';
import 'package:test_slicing/presentations/screens/ulasan/ulasan_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        Routes.transportasi: (context) => const Transportasi(),
        Routes.orderTransportasi: (context) => const OrderTransportasi(),
        Routes.orderTransportasiSuccess: (context) =>
            const TransportasiSuccessOrderScreen(),
      },
    );
  }
}
