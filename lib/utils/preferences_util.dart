import 'package:shared_preferences/shared_preferences.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/03
/// 描述：存儲對象
class Preferences {
  static final Preferences _instance = Preferences._internal();
  late SharedPreferences _prefs;

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs => _instance._prefs;
}
