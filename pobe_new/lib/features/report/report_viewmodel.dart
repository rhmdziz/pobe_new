import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pobe_new/core/services/report/report_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportViewModel extends ChangeNotifier {
  ReportViewModel(
    this._service, {
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();

  final ReportService _service;
  final ImagePicker _picker;

  bool isSubmitting = false;
  bool consentChecked = false;
  String? error;
  XFile? imageFile;
  String authorEmail = '';
  bool _emailLoaded = false;

  Future<void> loadAuthorEmail() async {
    if (_emailLoaded) return;
    _emailLoaded = true;
    final prefs = await SharedPreferences.getInstance();
    authorEmail = prefs.getString('email') ?? prefs.getString('username') ?? '';
    notifyListeners();
  }

  void toggleConsent(bool value) {
    consentChecked = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile = picked;
      notifyListeners();
    }
  }

  Future<bool> submit({
    required String title,
    required String content,
  }) async {
    if (!consentChecked) {
      error = 'Harap setujui ketentuan terlebih dahulu';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      await _service.submitReport(
        title: title,
        content: content,
        authorEmail: authorEmail,
        // imageFile: imageFile != null ? File(imageFile!.path) : null,
        imageFile: null,
      );
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
