import 'package:flutter/foundation.dart';
import 'package:pobe_new/core/services/profile/profile_service.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/data/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._service, this._authStorage);

  final ProfileService _service;
  final AuthStorage _authStorage;

  bool isLoading = false;
  String? error;
  UserProfile? profile;
  String cachedName = '';
  String? userUrl;

  Future<void> loadProfile() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      cachedName = prefs.getString('username') ?? '';
      userUrl = prefs.getString('url');

      profile = await _service.fetchProfile(overrideUrl: userUrl);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String get displayName {
    if (profile != null) return profile!.displayName;
    if (cachedName.isNotEmpty) return cachedName;
    return '-';
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await _authStorage.clear();
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('url');
  }

  Future<bool> openCustomerService() async {
    const url = 'https://wa.me/6285700435141?text=Hi,%20Aziz!';
    final uri = Uri.parse(url);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
