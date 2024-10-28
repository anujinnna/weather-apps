import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather_data_daily.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:weather_app/themes/custom_fonts.dart';
import 'package:weather_app/widgets/weather_detail.dart';

class DailyForecastScreen extends StatefulWidget {
  final WeatherDataDaily weatherDataDaily;
  const DailyForecastScreen({Key? key, required this.weatherDataDaily})
      : super(key: key);

  @override
  State<DailyForecastScreen> createState() => _DailyForecastScreenState();
}

class _DailyForecastScreenState extends State<DailyForecastScreen> {
  String getDay(final day) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    return DateFormat('EEE').format(time);
  }

  bool isToday(final day) {
    DateTime now = DateTime.now();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    return now.day == date.day &&
        now.month == date.month &&
        now.year == date.year;
  }

  bool isTomorrow(final day) {
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(const Duration(days: 1));
    DateTime date = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    return tomorrow.day == date.day &&
        tomorrow.month == date.month &&
        tomorrow.year == date.year;
  }

  @override
  Widget build(BuildContext context) {
    final dailyWeather = widget.weatherDataDaily.daily;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.dfirstGradientColor,
                  AppColors.dsecondGradientColor,
                  AppColors.dthirdGradientColor,
                  AppColors.dfourthGradientColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xff3f2891),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      Text(
                        "7 Days",
                        style: customFonts.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      WeatherCard(
                        daily: dailyWeather
                            .firstWhere((daily) => isTomorrow(daily.dt)),
                        getDay: getDay,
                      ),
                      const SizedBox(height: 2),
                      DailyWeatherWidget(
                        dailyWeather: dailyWeather
                            .where((daily) =>
                                !isToday(daily.dt) && !isTomorrow(daily.dt))
                            .take(5)
                            .toList(),
                        getDay: getDay,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final daily;
  final String Function(int) getDay;

  const WeatherCard({Key? key, required this.daily, required this.getDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.ddfirstGradientColor,
            AppColors.ddsecondGradientColor,
            AppColors.ddthirdGradientColor,
            AppColors.ddfourthGradientColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/weather/${daily.weather![0].icon}.png",
                  height: 120,
                  width: 120,
                ),
                const SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tomorrow",
                      style: customFonts.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${daily.weather?[0].description?.replaceFirst(daily.weather?[0].description![0], daily.weather?[0].description![0].toUpperCase()) ?? ''}",
                      style: customFonts.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${daily.temp!.max!.toStringAsFixed(0)}° / ${daily.temp!.min!.toStringAsFixed(0)}°",
                      style: customFonts.copyWith(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WeatherDetail(
                  image: "assets/icons/wind.png",
                  value: "${daily.windSpeed} km/h",
                  label: "Wind",
                ),
                WeatherDetail(
                  image: "assets/icons/sunrise.png",
                  value: daily.sunrise != null
                      ? DateFormat('h:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              daily.sunrise! * 1000))
                      : "N/A",
                  label: "Sunrise",
                ),
                WeatherDetail(
                  image: "assets/icons/sunset.png",
                  value: daily.sunset != null
                      ? DateFormat('h:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              daily.sunset! * 1000))
                      : "N/A",
                  label: "Sunset",
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class DailyWeatherWidget extends StatelessWidget {
  final List dailyWeather;
  final String Function(int) getDay;

  const DailyWeatherWidget(
      {Key? key, required this.dailyWeather, required this.getDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dailyWeather.length,
      itemBuilder: (context, index) {
        final daily = dailyWeather[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getDay(daily.dt),
                  style: customFonts.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 50),
                Image.asset(
                  "assets/weather/${daily.weather![0].icon}.png",
                  height: 50,
                  width: 50,
                ),
                const SizedBox(width: 9),
                Text(
                  "${daily.weather?[0].description?.replaceFirst(daily.weather?[0].description![0], daily.weather?[0].description![0].toUpperCase()) ?? ''}",
                  style: customFonts.copyWith(
                    fontSize: 13,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "${daily.temp!.max}°    ${daily.temp!.min}°",
                  style: customFonts.copyWith(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
