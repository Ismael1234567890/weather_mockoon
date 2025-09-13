// To parse this JSON data, do
//
//     final weatherData = weatherDataFromJson(jsonString);

import 'dart:convert';

WeatherData weatherDataFromJson(String str) =>
    WeatherData.fromJson(json.decode(str));

String weatherDataToJson(WeatherData data) => json.encode(data.toJson());

class WeatherData {
  Weather data;
  List<Warning> warnings;

  WeatherData({
    required this.data,
    required this.warnings,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        data: Weather.fromJson(json["data"]),
        warnings: List<Warning>.from(
            json["warnings"].map((x) => Warning.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "warnings": List<dynamic>.from(warnings.map((x) => x.toJson())),
      };
}

class Weather {
  List<Timeline> timelines;

  Weather({
    required this.timelines,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        timelines: List<Timeline>.from(
            json["timelines"].map((x) => Timeline.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "timelines": List<dynamic>.from(timelines.map((x) => x.toJson())),
      };
}

class Timeline {
  String timestep;
  DateTime startTime;
  DateTime endTime;
  List<WeatherInterval> intervals;

  Timeline({
    required this.timestep,
    required this.startTime,
    required this.endTime,
    required this.intervals,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        timestep: json["timestep"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        intervals: List<WeatherInterval>.from(
            json["intervals"].map((x) => WeatherInterval.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "timestep": timestep,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "intervals": List<dynamic>.from(intervals.map((x) => x.toJson())),
      };
}

class WeatherInterval {
  final String startTime;
  final WeatherValues values;

  WeatherInterval({
    required this.startTime,
    required this.values,
  });

  factory WeatherInterval.fromJson(Map<String, dynamic> json) {
    return WeatherInterval(
      startTime: json['startTime'],
      values: WeatherValues.fromJson(json['values']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'values': values.toJson(),
    };
  }
}

class WeatherValues {
  final double precipitationIntensity;
  final int precipitationType;
  final double windSpeed;
  final double windGust;
  final double windDirection;
  final double temperature;
  final double temperatureApparent;
  final double cloudCover;
  final double? cloudBase;
  final double? cloudCeiling;
  final int weatherCode;

  WeatherValues({
    required this.precipitationIntensity,
    required this.precipitationType,
    required this.windSpeed,
    required this.windGust,
    required this.windDirection,
    required this.temperature,
    required this.temperatureApparent,
    required this.cloudCover,
    this.cloudBase,
    this.cloudCeiling,
    required this.weatherCode,
  });

  factory WeatherValues.fromJson(Map<String, dynamic> json) {
    return WeatherValues(
      precipitationIntensity:
          (json['precipitationIntensity'] as num).toDouble(),
      precipitationType: json['precipitationType'],
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windGust: (json['windGust'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      temperatureApparent: (json['temperatureApparent'] as num).toDouble(),
      cloudCover: (json['cloudCover'] as num).toDouble(),
      cloudBase: json['cloudBase'] != null
          ? (json['cloudBase'] as num).toDouble()
          : null,
      cloudCeiling: json['cloudCeiling'] != null
          ? (json['cloudCeiling'] as num).toDouble()
          : null,
      weatherCode: json['weatherCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'precipitationIntensity': precipitationIntensity,
      'precipitationType': precipitationType,
      'windSpeed': windSpeed,
      'windGust': windGust,
      'windDirection': windDirection,
      'temperature': temperature,
      'temperatureApparent': temperatureApparent,
      'cloudCover': cloudCover,
      'cloudBase': cloudBase,
      'cloudCeiling': cloudCeiling,
      'weatherCode': weatherCode,
    };
  }

  // Méthodes utiles pour l'affichage
  String get temperatureCelsius =>
      ((temperature - 32) * 5 / 9).toStringAsFixed(1);
  String get temperatureApparentCelsius =>
      ((temperatureApparent - 32) * 5 / 9).toStringAsFixed(1);
  String get windSpeedKmh => (windSpeed * 1.60934).toStringAsFixed(1);

  String get weatherDescription {
    switch (weatherCode) {
      case 1000:
        return 'Dégagé';
      case 1100:
        return 'Plutôt dégagé';
      case 1101:
        return 'Partiellement nuageux';
      case 1102:
        return 'Plutôt nuageux';
      case 2000:
        return 'Brouillard';
      case 4000:
        return 'Bruine';
      case 4001:
        return 'Pluie';
      case 4200:
        return 'Pluie légère';
      default:
        return 'Inconnu';
    }
  }
}

class Warning {
  int code;
  String type;
  String message;
  Meta meta;

  Warning({
    required this.code,
    required this.type,
    required this.message,
    required this.meta,
  });

  factory Warning.fromJson(Map<String, dynamic> json) => Warning(
        code: json["code"],
        type: json["type"],
        message: json["message"],
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "type": type,
        "message": message,
        "meta": meta.toJson(),
      };
}

class Meta {
  String timestep;
  String from;
  String to;

  Meta({
    required this.timestep,
    required this.from,
    required this.to,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        timestep: json["timestep"],
        from: json["from"],
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "timestep": timestep,
        "from": from,
        "to": to,
      };
}
