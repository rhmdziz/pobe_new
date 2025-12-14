import 'package:flutter/foundation.dart';
import 'package:pobe_new/core/services/news/news_comment_service.dart';
import 'package:pobe_new/data/models/news_comment.dart';

class NewsDetailViewModel extends ChangeNotifier {
  NewsDetailViewModel(this._service);

  final NewsCommentService _service;

  bool isLoading = false;
  bool isSubmitting = false;
  String? error;
  List<NewsComment> comments = [];

  Future<void> load(int newsId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      comments = await _service.fetchComments(newsId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addComment({
    required int newsId,
    required String name,
    required String comment,
  }) async {
    isSubmitting = true;
    notifyListeners();
    try {
      await _service.addComment(newsId: newsId, name: name, comment: comment);
      await load(newsId);
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
