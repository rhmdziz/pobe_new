import 'package:flutter/material.dart';
import 'package:pobe_new/app/app_router.dart';
import 'package:pobe_new/features/home/category/to_go_viewmodel.dart';
import 'package:pobe_new/features/home/widgets/app_header.dart';
import 'package:provider/provider.dart';

class ToGoPage extends StatefulWidget {
  const ToGoPage({super.key, required this.category});

  final String category;

  @override
  State<ToGoPage> createState() => _ToGoPageState();
}

class _ToGoPageState extends State<ToGoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ToGoViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    const colorPrimary = Color.fromRGBO(31, 54, 113, 1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(title: widget.category),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Nearby ${widget.category}',
                style: const TextStyle(
                  color: colorPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<ToGoViewModel>(
                builder: (context, vm, _) {
                  if (vm.isLoading && vm.items.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vm.error != null && vm.items.isEmpty) {
                    return _ErrorState(
                      message: vm.error!,
                      onRetry: vm.load,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: vm.load,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: vm.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = vm.items[index];
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.categoryDetail,
                                arguments: item,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: item.imageUrl.isNotEmpty
                                        ? Image.network(
                                            item.imageUrl,
                                            width: 96,
                                            height: 96,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                _ImagePlaceholder(
                                              color: colorPrimary,
                                              label: item.name,
                                            ),
                                          )
                                        : _ImagePlaceholder(
                                            color: colorPrimary,
                                            label: item.name,
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(24, 24, 24, 1),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.description,
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(24, 24, 24, 0.8),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ...List.generate(
                                                  item.rating
                                                      .clamp(0, 5)
                                                      .toInt(),
                                                  (_) => const Icon(
                                                    Icons.star_rounded,
                                                    size: 18,
                                                    color: Color.fromRGBO(
                                                        255, 193, 7, 1),
                                                  ),
                                                ),
                                                if (item.reviewCount > 0)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 6),
                                                    child: Text(
                                                      '(${item.reviewCount})',
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            24, 24, 24, 0.8),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Row(
                                              children: List.generate(
                                                item.priceLevel
                                                    .clamp(0, 5)
                                                    .toInt(),
                                                (_) => const Icon(
                                                  Icons.attach_money,
                                                  size: 18,
                                                  color: Color.fromRGBO(
                                                      31, 54, 113, 1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        label.isNotEmpty ? label[0].toUpperCase() : '?',
        style: TextStyle(
          color: color,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
