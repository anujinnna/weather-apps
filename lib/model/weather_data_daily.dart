class WeatherDataDaily {
  List<Daily> daily;

  WeatherDataDaily({required this.daily});

  factory WeatherDataDaily.fromJson(Map<String, dynamic> json) =>
      WeatherDataDaily(
        daily: List<Daily>.from(
          json['daily'].map((e) => Daily.fromJson(e)),
        ),
      );

  Map<String, dynamic> toJson() => {
        'daily': daily.map((e) => e.toJson()).toList(),
      };
}

class Daily {
  int? dt;
  Temp? temp;
  int? sunrise;
  int? sunset;
  int? humidity;
  int? visibility;

  double? windSpeed;
  List<WeatherCondition>? weather;

  Daily({
    this.dt,
    this.temp,
    this.sunrise,
    this.sunset,
    this.visibility,
    this.humidity,
    this.windSpeed,
    this.weather,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        dt: json['dt'] as int?,
        temp: json['temp'] == null
            ? null
            : Temp.fromJson(json['temp'] as Map<String, dynamic>),
        sunrise: json['sunrise'] as int?,
        sunset: json['sunset'] as int?,
        humidity: json['humidity'] as int?,
        visibility: json['visibility'] as int?,
        windSpeed: (json['wind_speed'] as num?)?.toDouble(),
        weather: (json['weather'] as List<dynamic>?)
            ?.map((e) => WeatherCondition.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'temp': temp?.toJson(),
        'sunrise': sunrise,
        'sunset': sunset,
        'humidity': humidity,
        'visibility': visibility,
        'wind_speed': windSpeed,
        'weather': weather?.map((e) => e.toJson()).toList(),
      };
}

class Temp {
  double? day;
  int? min;
  int? max;
  double? night;
  double? eve;
  double? morn;

  Temp({
    this.day,
    this.min,
    this.max,
    this.night,
    this.eve,
    this.morn,
  });

  factory Temp.fromJson(Map<String, dynamic> json) => Temp(
        day: (json['day'] as num?)?.toDouble(),
        min: (json['min'] as num?)?.round(),
        max: (json['max'] as num?)?.round(),
        night: (json['night'] as num?)?.toDouble(),
        eve: (json['eve'] as num?)?.toDouble(),
        morn: (json['morn'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'min': min,
        'max': max,
        'night': night,
        'eve': eve,
        'morn': morn,
      };
}

class WeatherCondition {
  String? icon;
  String? description;

  WeatherCondition({
    this.icon,
    this.description,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) =>
      WeatherCondition(
        icon: json['icon'] as String?,
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'description': description,
      };
}
