import 'package:shared_preferences/shared_preferences.dart';
import 'sort_type.dart';

class SortPreference {
  static const _key = 'sort_type';

  Future<void> saveSortType(SortType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, type.name);
  }

  Future<SortType> loadSortType() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    return SortType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SortType.stars,
    );
  }
}
