// To parse this JSON data, do
//
//     final weatherData = weatherDataFromJson(jsonString);

import 'dart:convert';

WeatherData weatherDataFromJson(String str) => WeatherData.fromJson(json.decode(str));

String weatherDataToJson(WeatherData data) => json.encode(data.toJson());

class WeatherData {
    Data data;
    List<Warning> warnings;

    WeatherData({
        required this.data,
        required this.warnings,
    });

    factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        data: Data.fromJson(json["data"]),
        warnings: List<Warning>.from(json["warnings"].map((x) => Warning.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "warnings": List<dynamic>.from(warnings.map((x) => x.toJson())),
    };
}

class Data {
    List<Timeline> timelines;

    Data({
        required this.timelines,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        timelines: List<Timeline>.from(json["timelines"].map((x) => Timeline.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "timelines": List<dynamic>.from(timelines.map((x) => x.toJson())),
    };
}

class Timeline {
    String timestep;
    DateTime startTime;
    DateTime endTime;
    List<Interval> intervals;

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
        intervals: List<Interval>.from(json["intervals"].map((x) => Interval.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "timestep": timestep,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "intervals": List<dynamic>.from(intervals.map((x) => x.toJson())),
    };
}

class Interval {
    DateTime startTime;
    Map<String, double?> values;

    Interval({
        required this.startTime,
        required this.values,
    });

    factory Interval.fromJson(Map<String, dynamic> json) => Interval(
        startTime: DateTime.parse(json["startTime"]),
        values: Map.from(json["values"]).map((k, v) => MapEntry<String, double?>(k, v?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "startTime": startTime.toIso8601String(),
        "values": Map.from(values).map((k, v) => MapEntry<String, dynamic>(k, v)),
    };
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
