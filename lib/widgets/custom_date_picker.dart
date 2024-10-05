import 'package:flutter/cupertino.dart';
import 'package:gameify/utils/themes.dart';
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width / 3,
              height: 5,
              decoration: BoxDecoration(
                  color: Themes.secondary,
                  borderRadius: BorderRadius.circular(15)),
            ),
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
