import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get firebaseAndroidKey => _get('FIREBASE_ANDROID_KEY');
  static String get firebaseIOSKey => _get('FIREBASE_IOS_KEY');

  static String _get(String name) => DotEnv().env[name] ?? '';
}
