import 'package:flutter/material.dart';
import 'package:test_slicing/utils/constant.dart';

Container AuthButton(void Function() onPressed,
    {required Size size, required text, marginTop = 16.0, key}) {
  return Container(
    margin: EdgeInsets.only(top: marginTop),
    child: ElevatedButton(
      key: key,
      onPressed: onPressed,
      style: ButtonStyle(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        enableFeedback: false,
        overlayColor: MaterialStatePropertyAll(blue600),
        splashFactory: NoSplash.splashFactory,
        backgroundColor: MaterialStatePropertyAll(blue500),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        fixedSize: MaterialStateProperty.all(
          Size(size.width, 48.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: "Poppins",
        ),
      ),
    ),
  );
}
