import 'package:flutter/cupertino.dart';
import 'package:gameify/widgets/heat_map.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key, required this.onChanged});
  final Function(DateTime) onChanged;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 450,
        padding: const EdgeInsets.all(15),
        child: HeatMap(
            selectedDate: currentDate,
            onSelection: (newDate) {
              if (newDate == null) return;
              setState(() {
                currentDate = newDate;
              });
              widget.onChanged(newDate);
            },
            selectableDays: [0, 1, 2, 3, 4, 5, 6]));
  }
}
