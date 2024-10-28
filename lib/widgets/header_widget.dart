import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/themes/custom_fonts.dart';

class HeaderWidget extends StatefulWidget {
  final String city;

  const HeaderWidget({super.key, required this.city});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String date = DateFormat("yMMMMd").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          alignment: Alignment.center,
          child: Text(
            widget.city,
            style: customFonts.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
