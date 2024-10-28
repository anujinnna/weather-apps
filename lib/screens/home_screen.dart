import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/auth/services/login_or_register.dart';
import 'package:weather_app/controller/global_controller.dart';
import 'package:weather_app/data/provinces.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:weather_app/widgets/current_weather_widget.dart';
import 'package:weather_app/widgets/header_widget.dart';
import 'package:weather_app/widgets/hourly_data_widget.dart';
import 'package:weather_app/widgets/provider_check_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);
  String selectedCity = "Улаанбаатар";
  List<String> filteredProvinces = provinces.keys.toList();
  List<String> selectedProvinces = [];
  String searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather(selectedCity);
    _loadSelectedProvinces();
  }

  Future<void> _fetchWeather(String province) async {
    globalController.getLocationByCoordinates(
        provinces[province]?.latitude ?? 0,
        provinces[province]?.longitude ?? 0);
    setState(() {
      selectedCity = province;
    });
  }

  Future<void> _loadSelectedProvinces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedProvinces = prefs.getStringList('selectedProvinces') ?? [];
    });
  }

  void _filterProvinces(String query) {
    setState(() {
      searchQuery = query;
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredProvinces = [];
      } else {
        filteredProvinces = provinces.keys
            .where((province) =>
                province.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.firstGradientColor,
            AppColors.secondGradientColor,
            AppColors.thirdGradientColor,
            AppColors.fourthGradientColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(
          () {
            if (globalController.checkLoading().value) {
              return const Center(child: CircularProgressIndicator());
            }

            final weatherData = globalController.getData();
            if (weatherData == null) {
              return const Center(
                  child: Text('Цаг агаарын мэдээ байхгүй байна.'));
            }

            final currentWeather = weatherData.getCurrentWeather();
            final hourlyWeather = weatherData.getHourlyWeather();
            final dailyWeather = weatherData.getDailyWeather();

            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginOrRegisterPage()),
                                  );
                                },
                                icon: const Icon(Icons.person,
                                    color: Colors.white)),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextField(
                                  onChanged: _filterProvinces,
                                  decoration: InputDecoration(
                                    hintText: 'Хайх',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: const Icon(Icons.search),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        HeaderWidget(city: selectedCity),
                        if (currentWeather != null)
                          CurrentWeatherWidget(
                            weatherDataCurrent: currentWeather,
                          ),
                        const SizedBox(height: 10),
                        if (hourlyWeather != null && dailyWeather != null)
                          HourlyDataWidget(
                            weatherDataHourly: hourlyWeather,
                            weatherDataDaily: dailyWeather,
                          ),
                        const SizedBox(height: 10),
                        const ProviderCheck(),
                      ],
                    ),
                  ),
                  if (_isSearching && filteredProvinces.isNotEmpty)
                    Positioned(
                      top: 60,
                      left: 58,
                      right: 10,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 280,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: ListView.builder(
                            itemCount: filteredProvinces.length,
                            itemBuilder: (context, index) {
                              String province = filteredProvinces[index];
                              return ListTile(
                                title: Text(province),
                                onTap: () {
                                  setState(() {
                                    selectedCity = province;
                                    _fetchWeather(province);
                                    _isSearching = false;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
