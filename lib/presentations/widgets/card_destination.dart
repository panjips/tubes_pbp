// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:test_slicing/utils/constant.dart';

class CardDestination extends StatelessWidget {
  final String nama;
  final String alamat;
  final String? linkImage;
  const CardDestination({
    super.key,
    required this.nama,
    required this.alamat,
    this.linkImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 170,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  linkImage == null
                      ? "https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/destinasi%2Fbanner.png?alt=media&token=44df1d34-7c30-42aa-9e26-385b1a441de4"
                      : linkImage!,
                  headers: {
                    "Connection": "Keep-Alive",
                    "Keep-Alive": "timeout=10, max=10000",
                  }),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6, bottom: 2),
              child: Text(
                nama,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: slate900,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  FeatherIcons.mapPin,
                  size: 12,
                  color: slate400,
                ),
                Container(
                  margin: EdgeInsets.only(left: 2),
                  child: Text(
                    alamat,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: slate400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
