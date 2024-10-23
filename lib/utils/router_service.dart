import 'package:gameify/models/habit.dart';
import 'package:gameify/pages/add_habit_page.dart';
import 'package:gameify/pages/suggestions_page.dart';
import 'package:gameify/pages/loading_page.dart';
import 'package:gameify/pages/main_page.dart';
import 'package:gameify/pages/tutorial_page.dart';
import 'package:go_router/go_router.dart';

class RouterService {
  static GoRouter router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoadingPage(),
    ),
    GoRoute(
      path: '/tutorial',
      builder: (context, state) {
        assert(state.extra != null);
        String nextRoute = state.extra as String;
        return TutorialPage(nextRoute: nextRoute);
      },
    ),
    GoRoute(
      path: '/suggestions',
      builder: (context, state) => const SuggestionsPage(),
    ),
    GoRoute(
        path: '/main',
        builder: (context, state) => const MainPage(),
        routes: [
          GoRoute(
            path: '/addHabit',
            builder: (context, state) {
              List extras = state.extra as List;
              Function(Habit) onSubmit = extras[0] as Function(Habit);
              Habit? initialHabit = extras[1] as Habit?;
              return AddHabitPage(
                onSubmit: (habit) => onSubmit(habit),
                initialHabit: initialHabit,
              );
            },
          ),
        ])
  ]);
}
