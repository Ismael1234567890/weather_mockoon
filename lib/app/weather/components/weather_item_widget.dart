import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/data/models/weather_model.dart';
import '../controllers/weather_controller.dart';

class WeatherItemWidget extends StatelessWidget {
  final WeatherInterval weatherInterval;
  final bool isOffline;
  final VoidCallback? onTap;

  const WeatherItemWidget({
    super.key,
    required this.weatherInterval,
    this.isOffline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();
    final values = weatherInterval.values;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: isOffline
            ? Border.all(color: Colors.orange.withValues(alpha: 0.3), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(controller, values),
                const SizedBox(height: 16),
                _buildWeatherMetrics(values),
                if (isOffline) ...[
                  const SizedBox(height: 12),
                  _buildOfflineIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(WeatherController controller, WeatherValues values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.getFormattedTime(weatherInterval.startTime),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                controller.getFormattedDate(weatherInterval.startTime),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            color: _getWeatherColor(values.weatherCode),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getWeatherIcon(values.weatherCode),
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  values.weatherDescription,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherMetrics(WeatherValues values) {
    return Row(
      children: [
        Expanded(
          child: _buildWeatherMetric(
            icon: Icons.thermostat,
            label: 'Température',
            value: values.temperatureCelsius,
            unit: '°C',
            color: _getTemperatureColor(
                double.tryParse(values.temperatureCelsius) ?? 0),
          ),
        ),
        Expanded(
          child: _buildWeatherMetric(
            icon: Icons.thermostat_outlined,
            label: 'Ressenti',
            value: values.temperatureApparentCelsius,
            unit: '°C',
            color: Colors.deepOrange,
          ),
        ),
        Expanded(
          child: _buildWeatherMetric(
            icon: Icons.air,
            label: 'Vent',
            value: values.windSpeedKmh,
            unit: ' km/h',
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherMetric({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            children: [
              TextSpan(text: value),
              TextSpan(
                text: unit,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off,
            color: Colors.orange,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            'Données en cache',
            style: TextStyle(
              color: Colors.orange[700],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getWeatherColor(int weatherCode) {
    switch (weatherCode) {
      case 1000: // Clear
        return Colors.amber;
      case 1100: // Mostly Clear
        return Colors.orange;
      case 1101: // Partly Cloudy
        return Colors.grey;
      case 1102: // Mostly Cloudy
        return Colors.blueGrey;
      case 2000: // Fog
        return Colors.grey[700]!;
      case 4000: // Drizzle
        return Colors.lightBlue;
      case 4001: // Rain
        return Colors.blue;
      case 4200: // Light Rain
        return Colors.cyan;
      case 5000: // Snow
        return Colors.indigo;
      case 5001: // Flurries
        return Colors.indigo[300]!;
      case 6000: // Freezing Drizzle
        return Colors.purple;
      case 6001: // Freezing Rain
        return Colors.deepPurple;
      case 7000: // Ice Pellets
        return Colors.blueGrey[600]!;
      case 8000: // Thunderstorm
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  IconData _getWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 1000: // Clear
        return Icons.wb_sunny;
      case 1100: // Mostly Clear
        return Icons.wb_sunny_outlined;
      case 1101: // Partly Cloudy
        return Icons.precision_manufacturing;
      case 1102: // Mostly Cloudy
        return Icons.cloud;
      case 2000: // Fog
        return Icons.foggy;
      case 4000: // Drizzle
      case 4200: // Light Rain
        return Icons.grain;
      case 4001: // Rain
        return Icons.water_drop;
      case 5000: // Snow
      case 5001: // Flurries
        return Icons.ac_unit;
      case 6000: // Freezing Drizzle
      case 6001: // Freezing Rain
        return Icons.severe_cold;
      case 7000: // Ice Pellets
        return Icons.grain;
      case 8000: // Thunderstorm
        return Icons.thunderstorm;
      default:
        return Icons.help_outline;
    }
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature <= 0) {
      return Colors.blue;
    } else if (temperature <= 10) {
      return Colors.lightBlue;
    } else if (temperature <= 20) {
      return Colors.green;
    } else if (temperature <= 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
