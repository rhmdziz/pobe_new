import 'package:flutter/material.dart';
import 'package:pobe_new/features/home/dashboard/viewmodels/aqi_viewmodel.dart';
import 'package:provider/provider.dart';

class AirPolutionSection extends StatelessWidget {
  const AirPolutionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AqiViewModel>(
      builder: (context, vm, _) {
        vm.load();

        if (vm.isLoading && vm.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.error != null && vm.data == null) {
          return _ErrorState(
            message: vm.error!,
            onRetry: vm.refresh,
          );
        }

        final data = vm.data;
        if (data == null) {
          return const _ErrorState(message: 'No AQI data available');
        }

        final containerColor = _getColorForAQI(data.aqi);
        final status = _getStatusForAQI(data.aqi);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'l Air Pollution in BSD',
              style: TextStyle(
                color: Color.fromRGBO(31, 54, 113, 1),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: 150,
                        height: 150,
                        color: const Color.fromRGBO(0, 0, 0, 0.075),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/mask.png'),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 190,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.15),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${data.aqi}',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 46,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'AQI',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Last update: ${data.time}',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w400,
              ),
            ),
            if (vm.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _ErrorState(
                  message: vm.error!,
                  onRetry: vm.refresh,
                ),
              ),
          ],
        );
      },
    );
  }

  Color _getColorForAQI(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return const Color.fromRGBO(255, 138, 138, 1);
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }

  String _getStatusForAQI(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Error: $message',
          style: const TextStyle(color: Colors.red),
        ),
        if (onRetry != null)
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
      ],
    );
  }
}
