import 'package:flutter/foundation.dart';
import 'package:pobe_new/core/services/news/news_service.dart';
import 'package:pobe_new/data/models/news.dart';

enum NewsTab { trending, latest, lifestyle, politic, health, sport }

class NewsViewModel extends ChangeNotifier {
  NewsViewModel(this._service);

  final NewsService _service;

  bool isLoading = false;
  String? error;
  List<News> _allNews = [];
  NewsTab selectedTab = NewsTab.trending;
  bool _initialized = false;

  List<News> get filteredNews {
    final list = List<News>.from(_allNews);
    switch (selectedTab) {
      case NewsTab.latest:
        list.sort(
          (a, b) => DateTime.parse(b.datetime).compareTo(
            DateTime.parse(a.datetime),
          ),
        );
        return list;
      case NewsTab.trending:
        list.sort(
          (a, b) => int.parse(b.views).compareTo(int.parse(a.views)),
        );
        return list;
      case NewsTab.lifestyle:
        return list.where((n) => n.category.toLowerCase() == 'lifestyle').toList();
      case NewsTab.politic:
        return list.where((n) => n.category.toLowerCase() == 'politic').toList();
      case NewsTab.health:
        return list.where((n) => n.category.toLowerCase() == 'health').toList();
      case NewsTab.sport:
        return list.where((n) => n.category.toLowerCase() == 'sport').toList();
    }
  }

  List<News> get latestTopThree {
    final list = List<News>.from(_allNews);
    list.sort(
      (a, b) => DateTime.parse(b.datetime).compareTo(
        DateTime.parse(a.datetime),
      ),
    );
    return list.take(3).toList();
  }

  Future<void> load() async {
    if (_initialized) return;
    _initialized = true;
    await refresh();
  }

  Future<void> refresh() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _allNews = await _service.fetchNews();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectTab(NewsTab tab) {
    selectedTab = tab;
    notifyListeners();
  }
}
