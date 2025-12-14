import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pobe_new/features/home/widgets/app_header.dart';
import 'package:pobe_new/features/home/report/report_viewmodel.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportViewModel>().loadAuthorEmail();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer<ReportViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const PageHeader(title: 'Report'),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          _LabeledField(
                            label: 'Report Title',
                            isRequired: true,
                            child: TextFormField(
                              controller: _titleController,
                              decoration: _inputDecoration('Write a title'),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                      ? 'Judul wajib diisi'
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _LabeledField(
                            label: 'Tell us what happened?',
                            isRequired: true,
                            child: TextFormField(
                              controller: _contentController,
                              maxLines: 4,
                              decoration: _inputDecoration('Write a report'),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                      ? 'Cerita wajib diisi'
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Upload a File',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: vm.isSubmitting ? null : vm.pickImage,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(77, 133, 241, 0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.25),
                                ),
                              ),
                              child: _PreviewImage(imageFile: vm.imageFile),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '* Required',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 0, 0, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Checkbox(
                                value: vm.consentChecked,
                                onChanged: vm.isSubmitting
                                    ? null
                                    : (value) =>
                                        vm.toggleConsent(value ?? false),
                              ),
                              const Expanded(
                                child: Text(
                                  'By checking this box I am willing to follow the existing terms and conditions and am ready to accept sanctions if I am found to have violated the terms and conditions of PoBe',
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
                          if (vm.error != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              vm.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed:
                                vm.isSubmitting ? null : () => _submit(vm),
                            style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                Color.fromRGBO(31, 54, 113, 1),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              minimumSize: const WidgetStatePropertyAll(
                                Size(double.infinity, 50),
                              ),
                            ),
                            child: vm.isSubmitting
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text(
                                    'Send',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ],
                      ),
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

  Future<void> _submit(ReportViewModel vm) async {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid) return;

    final success = await vm.submit(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report sent successfully'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else if (vm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error!), backgroundColor: Colors.red),
      );
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
      filled: true,
      fillColor: const Color.fromRGBO(77, 133, 241, 0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Color.fromRGBO(255, 0, 0, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({required this.imageFile});

  final XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upload_file, size: 36, color: Colors.black54),
            SizedBox(height: 8),
            Text('Tap to upload'),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(imageFile!.path),
        fit: BoxFit.cover,
      ),
    );
  }
}
