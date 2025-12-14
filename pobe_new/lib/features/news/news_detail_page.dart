import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pobe_new/data/models/news.dart';
import 'package:pobe_new/data/models/news_comment.dart';
import 'package:pobe_new/features/news/viewmodels/news_detail_viewmodel.dart';
import 'package:pobe_new/features/home/widgets/error_state.dart';
import 'package:pobe_new/features/home/widgets/app_header.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({required this.news, super.key});

  final News news;

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsDetailViewModel>().load(widget.news.id);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<NewsDetailViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(title: 'News Detail'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          widget.news.title,
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${DateFormat('EEEE').format(DateTime.parse(widget.news.datetime))} ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(widget.news.datetime))} WIB',
                          style: const TextStyle(
                            color: Color.fromRGBO(31, 54, 113, 0.59),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7.5),
                          child: Image.network(
                            widget.news.image,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        HtmlWidget(
                          widget.news.content,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(50, 50, 50, 1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'by ${widget.news.author}',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.65),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.remove_red_eye_outlined, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              widget.news.views,
                              style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.65),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(206, 232, 253, 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Comments',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () => _showAddCommentModal(context, vm),
                          style: ButtonStyle(
                            backgroundColor: const WidgetStatePropertyAll(
                              Color.fromRGBO(31, 54, 113, 1),
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
                            'Add comment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (vm.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (vm.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: ErrorState(
                              message: vm.error!,
                              onRetry: () => vm.load(widget.news.id),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: vm.comments.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final comment = vm.comments[index];
                              return _CommentItem(comment: comment);
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

  void _showAddCommentModal(BuildContext context, NewsDetailViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
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
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Text(
                      'Comment',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 0, 0, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(77, 133, 241, 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    maxLines: 3,
                    controller: _commentController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write comment',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setModalState(() => _isChecked = value ?? false);
                      },
                    ),
                    const Flexible(
                      child: Text(
                        'By checking this box I agree to the terms and conditions of PoBe',
                        style: TextStyle(
                          color: Color.fromRGBO(31, 54, 113, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isChecked && !vm.isSubmitting
                      ? () async {
                          final name = await _readUsername() ?? 'user';
                          final comment = _commentController.text.trim();
                          if (comment.isEmpty) return;

                          final success = await vm.addComment(
                            newsId: widget.news.id,
                            name: name,
                            comment: comment,
                          );

                          if (!mounted) return;

                          if (success) {
                            _commentController.clear();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Comment added successfully!'),
                                backgroundColor: Color.fromRGBO(31, 54, 113, 1),
                              ),
                            );
                          } else if (vm.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(vm.error!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(
                      Color.fromRGBO(31, 54, 113, 1),
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
                  child: vm.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Send',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String?> _readUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}

class _CommentItem extends StatelessWidget {
  const _CommentItem({required this.comment});

  final NewsComment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage('assets/logo/user.png'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(31, 54, 113, 1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd-MM-yyyy HH:mm').format(comment.datetime),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color.fromRGBO(31, 54, 113, 0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${comment.comment}"',
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
          const Divider(color: Color.fromARGB(22, 0, 0, 0)),
        ],
      ),
    );
  }
}
