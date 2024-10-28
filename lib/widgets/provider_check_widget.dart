import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/api/fetch_weather.dart';
import 'package:weather_app/data/provinces.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:weather_app/themes/custom_fonts.dart';
import 'package:weather_app/widgets/add_province.dart';

class ProviderCheck extends StatefulWidget {
  const ProviderCheck({super.key});

  @override
  State<ProviderCheck> createState() => _ProviderCheckState();
}

class _ProviderCheckState extends State<ProviderCheck> {
  List<String> selectedProvinces = [];
  Map<String, String> provinceTemp = {};
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadProvince();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadProvince() async {
    setState(() {
      selectedProvinces = _prefs?.getStringList('selectedProvinces') ?? [];
    });
    await _fetchWeather();
  }

  void _saveProvince() {
    _prefs?.setStringList('selectedProvinces', selectedProvinces);
  }

  void _addProvince(String province) {
    if (!selectedProvinces.contains(province)) {
      setState(() {
        selectedProvinces.add(province);
        _saveProvince();
      });
      _fetchWeatherForProvince(province);
    }
  }

  void _removeProvince(String province) {
    setState(() {
      selectedProvinces.remove(province);
      provinceTemp.remove(province);
      _saveProvince();
    });
  }

  Future<void> _fetchWeather() async {
    for (var province in selectedProvinces) {
      await _fetchWeatherForProvince(province);
    }
  }

  Future<void> _fetchWeatherForProvince(String province) async {
    LatLng? provinceLatLon = provinces[province];
    if (provinceLatLon != null) {
      try {
        var weatherData = await FetchWeatherAPI().processData(
          provinceLatLon.latitude,
          provinceLatLon.longitude,
        );
        if (mounted) {
          setState(() {
            provinceTemp[province] =
                '${weatherData.current?.current?.temp?.toString() ?? '-'}°C';
          });
        }
      } catch (e) {
        setState(() {
          provinceTemp[province] = 'Failed to load';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Other provinces",
                style: customFonts.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProvince(
                        onProvinceSelected: (province) {
                          _addProvince(province);
                        },
                        selectedProvinces: selectedProvinces,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
        if (selectedProvinces.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: selectedProvinces
                    .map((province) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: AppColors.dividerLine,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                province,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                provinceTemp[province] ?? 'Loading...',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _removeProvince(province);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }
}
