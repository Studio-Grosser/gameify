import 'package:flutter/cupertino.dart';
import 'package:gameify/widgets/heat_map.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker(
      {super.key,
      required this.onChanged,
      required this.selectedDate,
      required this.heatFactors});
  final Function(DateTime) onChanged;
  final DateTime selectedDate;
  final Map<DateTime, double> heatFactors;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            HeatMap(
              data: widget.heatFactors,
              selectedDate: currentDate,
              onSelection: (newDate) {
                if (newDate == null) return;
                setState(() {
                  currentDate = newDate;
                });
                widget.onChanged(newDate);
              },
            ),
          ],
        ),
      ),
    );
  }
}
