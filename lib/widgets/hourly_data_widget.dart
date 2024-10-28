import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/controller/global_controller.dart';
import 'package:weather_app/model/weather_data_daily.dart';
import 'package:weather_app/model/weather_data_hourly.dart';
import 'package:weather_app/screens/daily_forecast_screen.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:weather_app/themes/custom_fonts.dart';

class HourlyDataWidget extends StatefulWidget {
  final WeatherDataHourly weatherDataHourly;
  final WeatherDataDaily weatherDataDaily;
  HourlyDataWidget(
      {Key? key,
      required this.weatherDataHourly,
      required this.weatherDataDaily})
      : super(key: key);

  @override
  State<HourlyDataWidget> createState() => _HourlyDataWidgetState();
}

class _HourlyDataWidgetState extends State<HourlyDataWidget> {
  RxInt cardIndex = GlobalController().getIndex();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today",
                style: customFonts.copyWith(color: Colors.white, fontSize: 14),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyForecastScreen(
                        weatherDataDaily: widget.weatherDataDaily,
                      ),
                    ),
                  );
                },
                child: Text(
                  "7-Day Forecasts ->",
                  style:
                      customFonts.copyWith(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        hourlyList(),
      ],
    );
  }

  Widget hourlyList() {
    return Container(
      height: 168,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.weatherDataHourly.hourly.length > 12
            ? 14
            : widget.weatherDataHourly.hourly.length,
        itemBuilder: (context, index) {
          final hourlyData = widget.weatherDataHourly.hourly[index];

          return Container(
            width: 82,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(31),
                color: AppColors.dividerLine),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTime(hourlyData.dt!, index),
                  buildWeatherIcon(hourlyData.weather![0].icon!, index),
                  buildTemperature(hourlyData.temp!, index),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTime(int timeStamp, int index) {
    String getTime(final timeStamp) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
      return DateFormat('jm').format(time);
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(getTime(timeStamp),
          style: customFonts.copyWith(
            color: Colors.white,
            fontSize: 13,
          )),
    );
  }

  Widget buildWeatherIcon(String weatherIcon, int index) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Image.asset(
        "assets/weather/$weatherIcon.png",
        height: 40,
        width: 40,
      ),
    );
  }

  Widget buildTemperature(int temp, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Text("$temp°",
          style: customFonts.copyWith(
            color: Colors.white,
            fontSize: 13,
          )),
    );
  }
}
