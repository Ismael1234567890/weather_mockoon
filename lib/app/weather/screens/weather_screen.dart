import '/app/weather/components/weather_item_widget.dart';

import '/app/weather/controllers/weather_controller.dart';
import '/constants/app_export.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});
  final controller = Get.find<WeatherController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Weather Forecast',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isOffline.value ? Icons.cloud_off : Icons.cloud,
                  color:
                      controller.isOffline.value ? Colors.orange : Colors.white,
                ),
                onPressed: () => _showStatusDialog(context, controller),
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.weatherTimelines.isEmpty) {
          return const _LoadingWidget();
        }

        if (controller.hasError.value && controller.weatherTimelines.isEmpty) {
          return _ErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.getWeatherList,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {},
          color: const Color(0xFF2196F3),
          child: Column(
            children: [
              // En-tête avec informations de statut
              _buildStatusHeader(),

              // Liste des données météo
              Expanded(
                child: controller.weatherTimelines.isEmpty
                    ? const _EmptyStateWidget()
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.weatherTimelines.length,
                        itemBuilder: (context, index) {
                          return WeatherItemWidget(
                            weatherInterval: controller.weatherTimelines[index].intervals.first,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusHeader() {
    return Obx(() {
      if (controller.isOffline.value || controller.lastUpdate.value != null) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          color: controller.isOffline.value
              ? Colors.orange.withValues(alpha: 0.1)
              : Colors.green.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(
                controller.isOffline.value ? Icons.cloud_off : Icons.update,
                color:
                    controller.isOffline.value ? Colors.orange : Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.isOffline.value
                      ? 'Offline mode - Last update: '
                      : 'Last update:',
                  style: TextStyle(
                    fontSize: 14,
                    color: controller.isOffline.value
                        ? Colors.orange[800]
                        : Colors.green[800],
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  void _showStatusDialog(BuildContext context, WeatherController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          controller.isOffline.value ? 'Offline Mode' : 'Online Mode',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.isOffline.value
                  ? 'You are currently viewing cached data.'
                  : 'Data is being fetched from the server.',
            ),
            const SizedBox(height: 8),
            Text('Last update: '),
            if (controller.weatherTimelines.isNotEmpty)
              Text('Items loaded: ${controller.weatherTimelines.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          if (controller.isOffline.value)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.getWeatherList();
              },
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading weather data...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_queue,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No weather data available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
