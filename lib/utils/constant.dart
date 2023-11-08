import 'package:flutter/material.dart';

const green600 = Color(0xFF16A34A);
const green700 = Color(0xFF15803D);
const slate50 = Color(0xFFF8FAFC);
const slate200 = Color(0xFFE2E8F0);
const slate300 = Color(0xFFCBD5E1);
const slate400 = Color(0xFF94A3B8);
const slate500 = Color(0xFF64748B);
const slate600 = Color(0xFF475569);
const slate700 = Color(0xFF334155);
const slate900 = Color(0xFF0F172A);
const blue500 = Color(0xFF3B82F6);
const blue600 = Color(0xFF2563EB);

List<BoxShadow> shadowMd = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    spreadRadius: -2.0,
    blurRadius: 4,
    blurStyle: BlurStyle.outer,
    offset: const Offset(0, 2),
  ),
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    spreadRadius: -1.0,
    blurRadius: 6,
    blurStyle: BlurStyle.outer,
    offset: const Offset(0, 4),
  ),
];
