import 'package:flutter/material.dart';
import 'package:gameify/database/database_service.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    DatabaseService.instance.isInitialized.then((isInitialized) {
      String route = isInitialized ? '/main' : '/tutorial';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(route);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()));
  }
}
