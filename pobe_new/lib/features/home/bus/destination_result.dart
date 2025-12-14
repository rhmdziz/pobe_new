import 'package:flutter/material.dart';
import 'package:pobe_new/features/home/bus/viewmodels/destination_result_viewmodel.dart';
import 'package:pobe_new/features/home/widgets/app_header.dart';
import 'package:provider/provider.dart';
import 'package:pobe_new/data/models/bus_schedule.dart';

class DestinationResult extends StatefulWidget {
  const DestinationResult({
    super.key,
    required this.startPoint,
    required this.endPoint,
    required this.fromTime,
    required this.toTime,
    required this.startPointId,
  });

  final String startPoint;
  final String endPoint;
  final String fromTime;
  final String toTime;
  final String startPointId;

  @override
  State<DestinationResult> createState() => _DestinationResultState();
}

class _DestinationResultState extends State<DestinationResult> {
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requested) return;
    _requested = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DestinationResultViewModel>().load(
            startPointId: widget.startPointId,
            endPoint: widget.endPoint,
            fromTime: widget.fromTime,
            toTime: widget.toTime,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<DestinationResultViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const PageHeader(title: 'Schedule'),
                  _SummaryCard(
                    startPoint: widget.startPoint,
                    endPoint: widget.endPoint,
                    fromTime: widget.fromTime,
                    toTime: widget.toTime,
                  ),
                  const SizedBox(height: 20),
                  if (vm.state == LoadState.loading)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    )
                  else if (vm.state == LoadState.error)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Error: ${vm.error}'),
                    )
                  else
                    _ScheduleList(
                      vm: vm,
                      endPoint: widget.endPoint,
                      fromTime: widget.fromTime,
                      toTime: widget.toTime,
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({
    required this.vm,
    required this.endPoint,
    required this.fromTime,
    required this.toTime,
  });

  final DestinationResultViewModel vm;
  final String endPoint;
  final String fromTime;
  final String toTime;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.schedules.length,
      itemBuilder: (context, index) {
          final schedule = vm.schedules[index];
          final halteName =
              vm.halteNames[schedule.halteId.toString()] ?? 'Unknown';
          final routeName =
              vm.routeNames[schedule.routeId] ?? 'Route ${schedule.routeId}';

          final routes = vm.routeStops[schedule.routeId] ?? [];
          if (!routes.contains(endPoint)) return const SizedBox.shrink();

        final times = schedule
            .timesWithinRange(fromTime, toTime)
            .map((e) => e['waktu']!)
            .toList();

        if (times.isEmpty) return const SizedBox.shrink();

        return Column(
          children: times.map((time) {
            return _ScheduleCard(
              schedule: schedule,
              halteName: halteName,
              routeName: routeName,
              time: time,
              onTap: () => _showScheduleDetails(
                context: context,
                schedule: schedule,
                halteName: halteName,
                endPoint: endPoint,
                routes: routes,
                time: time,
                routeName: routeName,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showScheduleDetails({
    required BuildContext context,
    required BusSchedule schedule,
    required String halteName,
    required String endPoint,
    required List<String> routes,
    required String time,
    required String routeName,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(250, 135, 0, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      routeName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _InfoChip(title: 'Starting Point', value: halteName),
                            _InfoChip(title: 'End Point', value: endPoint),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Departure: ${time.substring(0, 5)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 320),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: routes.map((stop) {
                                final isHighlighted =
                                    stop == halteName || stop == endPoint;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: isHighlighted ? const Color.fromRGBO(0, 148, 250, 1) : Colors.grey,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        stop,
                                        style: TextStyle(
                                          fontSize: isHighlighted ? 18 : 16,
                                          fontWeight: isHighlighted
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.schedule,
    required this.halteName,
    required this.routeName,
    required this.time,
    this.onTap,
  });

  final BusSchedule schedule;
  final String halteName;
  final String routeName;
  final String time;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 90,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(250, 135, 0, 1),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                  ),
                ),
                child: Image.asset(
                  'assets/icons/bus_white.png',
                  scale: 1.5,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              halteName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(46, 70, 197, 1),
                              ),
                              softWrap: true,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              routeName,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        time.substring(0, 5),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(46, 70, 197, 1),
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
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.startPoint,
    required this.endPoint,
    required this.fromTime,
    required this.toTime,
  });

  final String startPoint;
  final String endPoint;
  final String fromTime;
  final String toTime;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/icons/world_map.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),

        // CARD
        Positioned(
          bottom: 0,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$startPoint - $endPoint',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(23, 23, 23, 1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$fromTime - $toTime',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(31, 54, 113, 1),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // LINE + BUS ICON
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 16,
                        color: Color.fromRGBO(46, 70, 197, 1),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          indent: 8,
                          endIndent: 8,
                        ),
                      ),
                      SizedBox(
                        width: 32,
                        height: 20,
                        child: Image.asset(
                          'assets/icons/bus_blue.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          indent: 8,
                          endIndent: 8,
                        ),
                      ),
                      const Icon(
                        Icons.circle,
                        size: 16,
                        color: Color.fromRGBO(46, 70, 197, 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 144, 250, 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
