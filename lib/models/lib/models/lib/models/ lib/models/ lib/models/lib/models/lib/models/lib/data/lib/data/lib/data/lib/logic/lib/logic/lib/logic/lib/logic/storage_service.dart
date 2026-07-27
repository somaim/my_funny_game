import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_profile.dart';

class StorageService {
  static const String _profileKey = 'who_asked_player_profile_v1';

  Future<PlayerProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_profileKey);
    if (jsonStr == null) {
      return PlayerProfile.initial();
    }
    try {
      final Map<String, dynamic> map =
          jsonDecode(jsonStr) as Map<String, dynamic>;
      return PlayerProfile.fromJson(map);
    } catch (e) {
      return PlayerProfile.initial();
    }
  }

  Future<void> saveProfile(PlayerProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(profile.toJson());
    await prefs.setString(_profileKey, jsonStr);
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}
