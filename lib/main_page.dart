import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime currentDate;
  int score = 0;

  void changeDay(int offset) {
    setState(() {
      currentDate = currentDate.add(Duration(days: offset));
    });
  }

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => changeDay(-1),
                    icon: Icon(Icons.chevron_left)),
                Text(currentDate.toString()),
                IconButton(
                    onPressed: () => changeDay(1),
                    icon: Icon(Icons.chevron_right)),
              ],
            ),
            Text(score.toString())
          ],
        ),
      ),
    );
  }
}
