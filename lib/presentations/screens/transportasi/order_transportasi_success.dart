import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pbp/utils/constant.dart';
import 'package:animate_do/animate_do.dart';

class TransportasiSuccessOrderScreen extends StatelessWidget {
  const TransportasiSuccessOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BounceInUp(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: size.width * (2.5 / 4),
                      height: size.width * (2.5 / 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: green600.withOpacity(0.5),
                      ),
                    ),
                    Container(
                      width: size.width * (1.8 / 4),
                      height: size.width * (1.8 / 4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: green600,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.checkmark,
                      color: Colors.white,
                      size: size.width * (1 / 4),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 28),
                child: Text(
                  'Transaction Success!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: slate600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Happy Holiday!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: slate300,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 24, left: 24, bottom: 24),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed('/nav');
          },
          style: ButtonStyle(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            enableFeedback: false,
            overlayColor: const MaterialStatePropertyAll(blue600),
            splashFactory: NoSplash.splashFactory,
            backgroundColor: const MaterialStatePropertyAll(blue500),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            fixedSize: MaterialStateProperty.all(
              Size(size.width, 48.0),
            ),
          ),
          child: const Text(
            "Finish",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ),
    );
  }
}
