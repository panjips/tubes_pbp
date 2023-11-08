import 'package:flutter/material.dart';
import 'package:test_slicing/utils/constant.dart';

Container GoogleButton(Size size, String text) {
  return Container(
    margin: EdgeInsets.only(top: 16),
    width: size.width,
    height: 48,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: slate300,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          height: 24,
          width: 24,
          image: AssetImage('images/avatar-icon/google-icon.png'),
        ),
        Container(
          margin: EdgeInsets.only(left: 24),
          child: Text(
            '${text} With Gmail',
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              color: slate900,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    ),
  );
}
