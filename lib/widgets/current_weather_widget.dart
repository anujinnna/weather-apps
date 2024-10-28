import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather_data_current.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:weather_app/themes/custom_fonts.dart';
import 'package:weather_app/widgets/weather_detail.dart';

class CurrentWeatherWidget extends StatefulWidget {
  final WeatherDataCurrent weatherDataCurrent;

  const CurrentWeatherWidget({Key? key, required this.weatherDataCurrent})
      : super(key: key);

  @override
  State<CurrentWeatherWidget> createState() => _CurrentWeatherWidgetState();
}

class _CurrentWeatherWidgetState extends State<CurrentWeatherWidget> {
  String date = DateFormat("EEEE, d MMMM | h.mm a").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        temperatureAreaWidget(),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          alignment: Alignment.center,
          child: Text(
            date,
            style: customFonts.copyWith(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        currentWeatherMoreDetailsWidget(),
      ],
    );
  }

  Widget currentWeatherMoreDetailsWidget() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.dividerLine,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WeatherDetail(
                  image: "assets/icons/wind.png",
                  value: "${widget.weatherDataCurrent.current.windSpeed} km/h",
                  label: "Wind",
                ),
                WeatherDetail(
                  image: "assets/icons/cloud.png",
                  value: widget.weatherDataCurrent.current.visibility != null
                      ? "${(widget.weatherDataCurrent.current.visibility! / 1000).toStringAsFixed(1)} km"
                      : "N/A",
                  label: "Visibility",
                ),
                WeatherDetail(
                  image: "assets/icons/humidity.png",
                  value: "${widget.weatherDataCurrent.current.humidity} %",
                  label: "Humidity",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget temperatureAreaWidget() {
    String iconCode = (widget.weatherDataCurrent.current.weather != null &&
            widget.weatherDataCurrent.current.weather!.isNotEmpty &&
            widget.weatherDataCurrent.current.weather![0].icon != null)
        ? widget.weatherDataCurrent.current.weather![0].icon!
        : "default";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/weather/$iconCode.png",
          height: 150,
          width: 150,
        ),
        const SizedBox(width: 20),
        Text(
          "${widget.weatherDataCurrent.current.temp?.toInt() ?? '--'}°",
          style: customFonts.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 120,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
