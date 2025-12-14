import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pobe_new/core/services/bus/bus_schedule_service.dart';
import 'package:pobe_new/core/services/bus/halte_service.dart';
import 'package:pobe_new/data/models/halte.dart';
import 'package:pobe_new/features/home/bus/destination_result.dart';
import 'package:pobe_new/features/home/bus/viewmodels/destination_result_viewmodel.dart';
import 'package:pobe_new/features/home/bus/viewmodels/destination_viewmodel.dart';
import 'package:pobe_new/features/home/widgets/app_header.dart';
import 'package:provider/provider.dart';

class DestinationSet extends StatefulWidget {
  const DestinationSet({
    super.key,
    required this.startPoint,
    required this.endPoint,
  });

  final String startPoint;
  final String endPoint;

  @override
  State<DestinationSet> createState() => _DestinationSetState();
}

class _DestinationSetState extends State<DestinationSet> {
  final TextEditingController _startPointController = TextEditingController();
  final TextEditingController _endPointController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TransformationController _transformationController =
      TransformationController();

  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    final vm = context.read<DestinationViewModel>();
    vm.init(widget.startPoint, widget.endPoint);
    _startPointController.text = vm.startPoint;
    _endPointController.text = vm.endPoint;
    _fromTimeController.text = vm.fromTime;
    _toTimeController.text = vm.toTime;
  }

  @override
  void dispose() {
    _startPointController.dispose();
    _endPointController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _scale = (_scale * 1.2).clamp(1.0, 5.0);
      _transformationController.value = Matrix4.identity()..scale(_scale);
    });
  }

  void _zoomOut() {
    setState(() {
      _scale = (_scale / 1.2).clamp(1.0, 5.0);
      _transformationController.value = Matrix4.identity()..scale(_scale);
    });
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
    void Function(String) onChanged,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      final value =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() => controller.text = value);
      onChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Consumer<DestinationViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const PageHeader(title: 'Schedule'),
                  _InputCard(
                    startPointController: _startPointController,
                    endPointController: _endPointController,
                    fromTimeController: _fromTimeController,
                    toTimeController: _toTimeController,
                    onSelectStart: vm.selectStart,
                    onSelectEnd: vm.selectEnd,
                    onFind: () => _handleFind(vm),
                    selectTime: (ctx, controller) => _selectTime(
                      ctx,
                      controller,
                      (value) {
                        if (controller == _fromTimeController) {
                          vm.setFromTime(value);
                        } else {
                          vm.setToTime(value);
                        }
                      },
                    ),
                    getSuggestions: vm.searchHaltes,
                  ),
                  const SizedBox(height: 20),
                  _RouteMap(
                    transformationController: _transformationController,
                    onZoomIn: _zoomIn,
                    onZoomOut: _zoomOut,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleFind(DestinationViewModel vm) {
    final start = _startPointController.text.trim();
    final end = _endPointController.text.trim();
    final from = _fromTimeController.text.trim();
    final to = _toTimeController.text.trim();

    if (start.isEmpty || end.isEmpty || from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua field terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => DestinationResultViewModel(
            BusScheduleService(),
            HalteService(),
          ),
          child: DestinationResult(
            startPoint: vm.startPoint,
            endPoint: vm.endPoint,
            fromTime: vm.fromTime,
            toTime: vm.toTime,
            startPointId: vm.startPointId,
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.startPointController,
    required this.endPointController,
    required this.fromTimeController,
    required this.toTimeController,
    required this.onSelectStart,
    required this.onSelectEnd,
    required this.onFind,
    required this.selectTime,
    required this.getSuggestions,
  });

  final TextEditingController startPointController;
  final TextEditingController endPointController;
  final TextEditingController fromTimeController;
  final TextEditingController toTimeController;
  final ValueChanged<Halte> onSelectStart;
  final ValueChanged<Halte> onSelectEnd;
  final VoidCallback onFind;
  final Future<void> Function(BuildContext, TextEditingController) selectTime;
  final Future<List<Halte>> Function(String) getSuggestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insert your starting point',
              style: TextStyle(
                color: Color.fromARGB(255, 26, 159, 255),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 8),
            _SuggestionField(
              controller: startPointController,
              hintText: 'Starting Point ...',
              asset: 'assets/icons/starting.png',
              onSelected: onSelectStart,
              getSuggestions: getSuggestions,
            ),
            const SizedBox(height: 15),
            const Text(
              'Insert your end point',
              style: TextStyle(
                color: Color.fromARGB(255, 26, 159, 255),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 8),
            _SuggestionField(
              controller: endPointController,
              hintText: 'End Point ...',
              asset: 'assets/icons/end.png',
              onSelected: onSelectEnd,
              getSuggestions: getSuggestions,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TimeInput(
                  label: 'From',
                  controller: fromTimeController,
                  selectTime: selectTime,
                ),
                _TimeInput(
                  label: 'To',
                  controller: toTimeController,
                  selectTime: selectTime,
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onFind,
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(
                  Color.fromRGBO(31, 54, 113, 1),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                minimumSize: const WidgetStatePropertyAll(
                  Size(double.infinity, 50),
                ),
              ),
              child: const Text(
                'Find Transportation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SuggestionField extends StatelessWidget {
  const _SuggestionField({
    required this.controller,
    required this.hintText,
    required this.asset,
    required this.onSelected,
    required this.getSuggestions,
  });

  final TextEditingController controller;
  final String hintText;
  final String asset;
  final ValueChanged<Halte> onSelected;
  final Future<List<Halte>> Function(String) getSuggestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Image.asset(asset),
            const SizedBox(width: 15),
            Expanded(
              child: TypeAheadField<Halte>(
                controller: controller,
                builder: (context, textController, focusNode) => TextField(
                  controller: textController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    border:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 26, 159, 255),
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w300,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                  ),
                ),
                hideKeyboardOnDrag: true,
                itemBuilder: (context, halte) {
                  return ListTile(title: Text(halte.name));
                },
                onSelected: (halte) {
                  controller.text = halte.name;
                  onSelected(halte);
                },
                suggestionsCallback: getSuggestions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeInput extends StatelessWidget {
  const _TimeInput({
    required this.label,
    required this.controller,
    required this.selectTime,
  });

  final String label;
  final TextEditingController controller;
  final Future<void> Function(BuildContext, TextEditingController) selectTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 26, 159, 255),
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.25)),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            readOnly: true,
            textAlign: TextAlign.center,
            onTap: () => selectTime(context, controller),
            decoration: const InputDecoration(
              hintText: '--:--',
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 26, 159, 255),
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            keyboardType: TextInputType.datetime,
          ),
        ),
      ],
    );
  }
}

class _RouteMap extends StatelessWidget {
  const _RouteMap({
    required this.transformationController,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  final TransformationController transformationController;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(250, 135, 0, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.5),
                topRight: Radius.circular(7.5),
              ),
            ),
            child: const Text(
              'BSD Link',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Lexend',
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Color.fromRGBO(250, 135, 0, 1),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InteractiveViewer(
                  transformationController: transformationController,
                  minScale: 1.0,
                  maxScale: 2.0,
                  constrained: true,
                  child: Image.asset(
                    'assets/images/bsdlink_route.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: onZoomIn,
                elevation: 0,
                heroTag: 'zoomInBus',
                child: const Icon(Icons.zoom_in, color: Colors.black),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: onZoomOut,
                elevation: 0,
                heroTag: 'zoomOutBus',
                child: const Icon(Icons.zoom_out, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
