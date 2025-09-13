import '/app/weather/components/empty_view.dart';
import '/app/weather/components/error_view.dart';
import '/app/weather/components/loading_view.dart';
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
          return const LoadingWidget();
        }

        if (controller.hasError.value && controller.weatherTimelines.isEmpty) {
          return MyErrorWidget(
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
                    ? const EmptyStateWidget()
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.weatherTimelines.length,
                        itemBuilder: (context, index) {
                          return WeatherItemWidget(
                            weatherInterval: controller
                                .weatherTimelines[index].intervals.first,
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
                      ? 'Mode hors ligne - Dernière mise à jour : ${controller.getFormattedDate(controller.lastUpdate.value.toString())} '
                      : 'Dernière mise à jour : ${controller.getFormattedDate(controller.lastUpdate.value.toString())}',
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
          controller.isOffline.value ? 'Mode hors ligne' : 'Mode en ligne',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.isOffline.value
                  ? 'Vous consultez actuellement des données mises en cache.'
                  : 'Les données sont en cours de récupération depuis le serveur.',
            ),
            const SizedBox(height: 8),
            Text('Dernière mise à jour : ${controller.getFormattedDate(controller.lastUpdate.value.toString())}'),
            if (controller.weatherTimelines.isNotEmpty)
              Text('Éléments chargés : ${controller.weatherTimelines.length}'),
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
