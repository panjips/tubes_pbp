import 'package:flutter/material.dart';
import 'package:test_slicing/utils/constant.dart';

Container DividerAuth() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 12),
    child: Stack(
      alignment: Alignment.center,
      children: [
        const Divider(
          color: slate300,
        ),
        Container(
          width: 50,
          color: slate50,
          child: const Text(
            "or",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              color: slate400,
            ),
          ),
        ),
      ],
    ),
  );
}
