import 'package:gameify/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionUtils {
  // After this Duration, the session is considered ended
  // and the date will be resetted to today
  static const _maxSessionDuration = Duration(minutes: 30);
  static const _lastSessionKey = 'last_session';

  static void registerSession() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime now = DateTime.now();
      await prefs.setString(_lastSessionKey, now.toIso8601String());
      Logger.s('New session registered: $now');
    } catch (e, st) {
      Logger.e('Error registering new session: ${e.toString()}', st);
    }
  }

  static Future<DateTime?> _getLastSession() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? lastSession = prefs.getString(_lastSessionKey);
      if (lastSession == null) return null;
      return DateTime.tryParse(lastSession);
    } catch (e, st) {
      Logger.e('Error getting last session: ${e.toString()}', st);
      return null;
    }
  }

  static Future<bool> isSessionExpired() async {
    try {
      DateTime? lastSession = await _getLastSession();
      if (lastSession == null) return true;
      DateTime now = DateTime.now();
      Duration diff = now.difference(lastSession);
      Logger.i('Time between last session and now: ${diff.inMinutes} minutes');
      return diff.inMinutes > _maxSessionDuration.inMinutes;
    } catch (e, st) {
      Logger.e('Error checking if session is expired: ${e.toString()}', st);
      return true;
    }
  }
}
