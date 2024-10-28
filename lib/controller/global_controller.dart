import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/api/fetch_weather.dart';
import 'package:weather_app/model/weather_data.dart';

class GlobalController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  final Rx<WeatherData?> weatherData = Rx<WeatherData?>(null);

  RxBool checkLoading() => _isLoading;
  RxDouble getLatitude() => _latitude;
  RxDouble getLongitude() => _longitude;

  WeatherData? getData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    getLocation();
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error("Байршил идэвхигүй байна. ");
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied.");
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location permissions denied.");
      }
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      _latitude.value = value.latitude;
      _longitude.value = value.longitude;

      FetchWeatherAPI()
          .processData(value.latitude, value.longitude)
          .then((weather) {
        weatherData.value = weather;
        _isLoading.value = false;
      }).catchError((error) {
        _isLoading.value = false;
      });
    });
  }

  void getLocationByCoordinates(double lat, double lon) async {
    _latitude.value = lat;
    _longitude.value = lon;

    _isLoading.value = true;

    FetchWeatherAPI().processData(lat, lon).then((weather) {
      weatherData.value = weather;
      _isLoading.value = false;
    }).catchError((error) {
      _isLoading.value = false;
    });
  }

  RxInt getIndex() {
    return _currentIndex;
  }
}
