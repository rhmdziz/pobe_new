import 'package:flutter/foundation.dart';
import 'package:pobe_new/core/services/category/to_go_service.dart';
import 'package:pobe_new/data/models/to_go_item.dart';
import 'package:pobe_new/data/models/to_go_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToGoDetailViewModel extends ChangeNotifier {
  ToGoDetailViewModel(this._service, {required this.item});

  final ToGoService _service;
  final ToGoItem item;

  bool isLoading = false;
  bool isSubmitting = false;
  String? error;
  List<ToGoReview> reviews = [];
  int selectedRating = 0;
  String reviewText = '';
  String userName = '';
  bool consentChecked = false;

  Future<void> init() async {
    await Future.wait([
      _loadUserName(),
      loadReviews(),
    ]);
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('username') ?? 'User';
  }

  Future<void> loadReviews() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      reviews = await _service.fetchReviews(item.id);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateRating(int rating) {
    selectedRating = rating;
    notifyListeners();
  }

  void updateReviewText(String value) {
    reviewText = value;
  }

  void toggleConsent(bool value) {
    consentChecked = value;
    notifyListeners();
  }

  Future<bool> submitReview() async {
    if (!consentChecked) {
      error = 'Setujui syarat dan ketentuan terlebih dahulu';
      notifyListeners();
      return false;
    }
    if (selectedRating <= 0 || reviewText.isEmpty) {
      error = 'Isi rating dan review';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      await _service.submitReview(
        itemId: item.id,
        rating: selectedRating,
        name: userName,
        review: reviewText,
      );
      reviewText = '';
      selectedRating = 0;
      consentChecked = false;
      await loadReviews();
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
