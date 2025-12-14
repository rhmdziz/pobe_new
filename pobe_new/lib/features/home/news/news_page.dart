import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pobe_new/app/app_router.dart';
import 'package:pobe_new/data/models/news.dart';
import 'package:pobe_new/features/home/news/viewmodels/news_viewmodel.dart';
import 'package:pobe_new/features/home/widgets/error_state.dart';
import 'package:pobe_new/features/home/widgets/news_header.dart';
import 'package:provider/provider.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'News'),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<NewsViewModel>(
                builder: (context, vm, _) {
                  if (vm.isLoading && vm.filteredNews.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vm.error != null && vm.filteredNews.isEmpty) {
                    return ErrorState(
                      message: vm.error!,
                      onRetry: vm.refresh,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: vm.refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          _TopCarousel(news: vm.latestTopThree),
                          const SizedBox(height: 12),
                          _NewsTabs(
                            selectedTab: vm.selectedTab,
                            onTabSelected: vm.selectTab,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _NewsList(news: vm.filteredNews),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopCarousel extends StatelessWidget {
  const _TopCarousel({required this.news});

  final List<News> news;

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(31, 54, 113, 1),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: news.length,
        itemBuilder: (context, index) {
          final item = news[index];
          return GestureDetector(
            onTap: () => _openDetail(context, item),
            child: Container(
              width: 300,
              margin: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.075),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.image,
                      height: 210,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${item.author} | ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(item.datetime))}',
                            style: const TextStyle(
                              color: Color.fromRGBO(231, 125, 48, 1),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NewsTabs extends StatelessWidget {
  const _NewsTabs({
    required this.selectedTab,
    required this.onTabSelected,
  });

  final NewsTab selectedTab;
  final ValueChanged<NewsTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      NewsTab.trending,
      NewsTab.latest,
      NewsTab.lifestyle,
      NewsTab.politic,
      NewsTab.health,
      NewsTab.sport,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final tab in tabs) ...[
              GestureDetector(
                onTap: () => onTabSelected(tab),
                child: Text(
                  _tabLabel(tab),
                  style: TextStyle(
                    color: selectedTab == tab
                        ? const Color.fromRGBO(231, 125, 48, 1)
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (tab != tabs.last) const SizedBox(width: 24),
            ],
          ],
        ),
      ),
    );
  }

  String _tabLabel(NewsTab tab) {
    switch (tab) {
      case NewsTab.trending:
        return 'Trending';
      case NewsTab.latest:
        return 'Latest';
      case NewsTab.lifestyle:
        return 'Lifestyle';
      case NewsTab.politic:
        return 'Politic';
      case NewsTab.health:
        return 'Health';
      case NewsTab.sport:
        return 'Sport';
    }
  }
}

class _NewsList extends StatelessWidget {
  const _NewsList({required this.news});

  final List<News> news;

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) {
      return const Center(child: Text('No news available'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: news.length,
      itemBuilder: (context, index) {
        final item = news[index];
        return Card(
          child: GestureDetector(
            onTap: () => _openDetail(context, item),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.5, horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.075),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7.5),
                    child: Image.network(
                      item.image,
                      width: 125,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${item.author} | ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.datetime))}',
                            style: const TextStyle(
                              color: Color.fromRGBO(231, 125, 48, 1),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void _openDetail(BuildContext context, News news) {
  Navigator.pushNamed(context, AppRouter.newsDetail, arguments: news).then((_) {
    if (context.mounted) {
      context.read<NewsViewModel>().refresh();
    }
  });
}
