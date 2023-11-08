import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:test_slicing/utils/constant.dart';

class OrderTicketScreen extends StatefulWidget {
  const OrderTicketScreen({super.key});

  @override
  State<OrderTicketScreen> createState() => _OrderTicketScreenState();
}

class _OrderTicketScreenState extends State<OrderTicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: slate50,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            FeatherIcons.chevronLeft,
            size: 32,
            color: slate900,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Order Ticket",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            color: slate900,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(),
    );
  }
}
