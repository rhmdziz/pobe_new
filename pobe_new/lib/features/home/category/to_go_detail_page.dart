import 'package:flutter/material.dart';
import 'package:pobe_new/features/home/category/to_go_detail_viewmodel.dart';
import 'package:pobe_new/features/home/widgets/app_header.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _colorPrimary = Color.fromRGBO(31, 54, 113, 1);

class ToGoDetailPage extends StatefulWidget {
  const ToGoDetailPage({super.key});

  @override
  State<ToGoDetailPage> createState() => _ToGoDetailPageState();
}

class _ToGoDetailPageState extends State<ToGoDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ToGoDetailViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ToGoDetailViewModel>(
          builder: (context, vm, _) {
            final item = vm.item;
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  PageHeader(title: item.name),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: item.imageUrl.isNotEmpty
                                ? Image.network(
                                    item.imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: _colorPrimary.withOpacity(0.1),
                                    alignment: Alignment.center,
                                    child: Text(
                                      item.name.isNotEmpty
                                          ? item.name[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'More Info',
                              style: TextStyle(
                                color: _colorPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  item.rating.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.star_rounded,
                                    color: Colors.amber, size: 20),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _InfoRow(
                          icon: 'assets/icons/loc.png',
                          text: item.location ?? '-',
                        ),
                        _InfoRow(
                          icon: 'assets/icons/hour.png',
                          text:
                              '${item.operationalDay ?? '-'} (${item.operationalHour ?? '-'})',
                        ),
                        _InfoRow(
                          icon: 'assets/icons/call.png',
                          text: item.phone ?? '-',
                        ),
                        _InfoRow(
                          icon: 'assets/icons/price_blue.png',
                          text:
                              '${item.minPrice ?? ''}${item.maxPrice ?? ''} / person',
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: Colors.black26),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    _showAddReviewModal(context, vm),
                                style: ButtonStyle(
                                  backgroundColor: const WidgetStatePropertyAll(
                                    Color.fromRGBO(209, 235, 254, 1),
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  minimumSize: const WidgetStatePropertyAll(
                                    Size(double.infinity, 50),
                                  ),
                                ),
                                child: const Text(
                                  'Add a review',
                                  style: TextStyle(
                                    color: _colorPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    _openMaps(item.latitude, item.longitude),
                                style: ButtonStyle(
                                  backgroundColor: const WidgetStatePropertyAll(
                                    _colorPrimary,
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  minimumSize: const WidgetStatePropertyAll(
                                    Size(double.infinity, 50),
                                  ),
                                ),
                                child: const Text(
                                  'Directions',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Colors.black26),
                        if (vm.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (vm.error != null)
                          _ErrorState(
                            message: vm.error!,
                            onRetry: vm.loadReviews,
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: vm.reviews.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final review = vm.reviews[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage(
                                              'assets/logo/user.png'),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                review.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: _colorPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: List.generate(
                                                  review.rating,
                                                  (_) => const Icon(
                                                    Icons.star_rounded,
                                                    size: 18,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '"${review.review}"',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      color: Color.fromARGB(22, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openMaps(double? lat, double? lng) async {
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi tidak tersedia')),
      );
      return;
    }
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka Google Maps')),
      );
    }
  }

  void _showAddReviewModal(BuildContext context, ToGoDetailViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ChangeNotifierProvider.value(
        value: vm,
        child: Consumer<ToGoDetailViewModel>(
          builder: (context, vmSheet, _) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Rating *',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        onPressed: () => vmSheet.updateRating(index + 1),
                        icon: Icon(
                          Icons.star_rounded,
                          color: index < vmSheet.selectedRating
                              ? Colors.amber
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Review *',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    onChanged: vmSheet.updateReviewText,
                    decoration: const InputDecoration(
                      hintText: 'Write a review',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: vmSheet.consentChecked,
                        onChanged: (value) =>
                            vmSheet.toggleConsent(value ?? false),
                      ),
                      const Expanded(
                        child: Text(
                          'Dengan ini saya setuju dengan syarat dan ketentuan PoBe.',
                          style: TextStyle(
                            color: Color.fromRGBO(31, 54, 113, 1),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vmSheet.isSubmitting
                          ? null
                          : () async {
                              final success = await vmSheet.submitReview();
                              if (!mounted) return;
                              if (success) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Review added successfully'),
                                    backgroundColor: _colorPrimary,
                                  ),
                                );
                              } else if (vmSheet.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(vmSheet.error!),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _colorPrimary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: vmSheet.isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text('Send'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Image.asset(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
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
      child: Column(
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.red),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
