import 'package:flutter/cupertino.dart';
import 'package:gameify/widgets/date_picker/calendar.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          height: 410,
          child: Calendar(
            selectedDate: currentDate,
            onSelection: (newDate) {
              if (newDate == null) return;
              setState(() {
                currentDate = newDate;
              });
              widget.onChanged(newDate);
            },
          ),
        ),
      ),
    );
  }
}
