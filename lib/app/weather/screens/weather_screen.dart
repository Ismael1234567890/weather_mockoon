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
        if (controller.isLoading.value && controller.weatherTimelines.isEmpty ||
            controller.isRefreshing.value) {
          return const LoadingWidget();
        }

        if (controller.hasError.value && controller.weatherTimelines.isEmpty) {
          return MyErrorWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.getWeatherList(isRefreshing: true),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.getWeatherList(isRefreshing: true);

            // Attendre la fin de l'opération
            while (
                controller.isRefreshing.value || controller.isLoading.value) {
              await Future.delayed(const Duration(milliseconds: 50));
            }
          },
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
                        itemCount: _getTotalItemsCount(), // ← Nouveau calcul
                        itemBuilder: (context, index) {
                          final itemData =
                              _getItemAtIndex(index); // ← Nouvelle méthode
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // En-tête de section si c'est le premier élément d'une timeline
                              if (itemData['isFirstOfTimeline'])
                                _buildTimelineHeader(itemData['timestep']),

                              // Widget météo
                              WeatherItemWidget(
                                weatherInterval: itemData['interval'],
                              ),
                            ],
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

  int _getTotalItemsCount() {
    return controller.weatherTimelines
        .map((timeline) => timeline.intervals.length)
        .fold(0, (sum, count) => sum + count);
  }

  // Récupérer l'élément à l'index donné en parcourant toutes les timelines
  Map<String, dynamic> _getItemAtIndex(int globalIndex) {
    int currentIndex = 0;

    for (int timelineIndex = 0;
        timelineIndex < controller.weatherTimelines.length;
        timelineIndex++) {
      final timeline = controller.weatherTimelines[timelineIndex];

      for (int intervalIndex = 0;
          intervalIndex < timeline.intervals.length;
          intervalIndex++) {
        if (currentIndex == globalIndex) {
          return {
            'interval': timeline.intervals[intervalIndex],
            'timestep': timeline.timestep,
            'isFirstOfTimeline': intervalIndex == 0,
          };
        }
        currentIndex++;
      }
    }

    return {
      'interval': controller.weatherTimelines.first.intervals.first,
      'timestep': controller.weatherTimelines.first.timestep,
      'isFirstOfTimeline': false,
    };
  }

  // En-tête pour chaque section de timeline
  Widget _buildTimelineHeader(String timestep) {
    String title;
    String subtitle;
    Color color;

    switch (timestep) {
      case 'current':
        title = 'Conditions actuelles';
        subtitle = 'Maintenant';
        color = Colors.black;
        break;
      case '1h':
        title = 'Prévisions horaires';
        subtitle = 'Prochaines 24 heures';
        color = Colors.blue;
        break;
      case '1d':
        title = 'Prévisions journalières';
        subtitle = 'Prochains jours';
        color = Colors.green;
        break;
      default:
        title = 'Prévisions';
        subtitle = timestep;
        color = Colors.grey;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.fromBorderSide(BorderSide(
            color: color,
            width: 4,
          ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: color.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
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
            Text(
                'Dernière mise à jour : ${controller.getFormattedDate(controller.lastUpdate.value.toString())}'),
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
