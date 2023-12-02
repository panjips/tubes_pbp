import 'package:flutter/material.dart';
import 'package:test_slicing/utils/constant.dart';

TextFormField inputForm(
  Function(String?) validator, {
  required controller,
  required hintText,
  obsecureText = false,
  Key? key,
}) {
  return TextFormField(
    key: key,
    validator: (value) => validator(value),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    obscureText: obsecureText,
    textAlignVertical: TextAlignVertical.center,
    controller: controller,
    style: const TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      color: slate900,
    ),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      hintText: hintText,
      hintStyle: const TextStyle(
        fontFamily: "Poppins",
        fontSize: 14,
        color: slate400,
      ),
      errorStyle: const TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        fontSize: 10,
        color: Colors.red,
      ),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: slate300),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

Container labelInput({required text, top = 0.0, bottom = 0.0}) {
  return Container(
    margin: EdgeInsets.only(top: top, bottom: bottom),
    child: Text(
      text,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: slate900,
      ),
    ),
  );
}
