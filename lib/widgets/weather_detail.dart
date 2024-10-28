import 'package:flutter/material.dart';
import 'package:weather_app/themes/custom_fonts.dart';

class WeatherDetail extends StatelessWidget {
  final String image;
  final String value;
  final String label;

  const WeatherDetail({
    Key? key,
    required this.image,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(image),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: customFonts.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: customFonts.copyWith(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
