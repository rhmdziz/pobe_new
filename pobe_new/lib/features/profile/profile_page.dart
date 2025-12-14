import 'package:flutter/material.dart';
import 'package:pobe_new/app/app_router.dart';
import 'package:pobe_new/features/profile/profile_viewmodel.dart';
import 'package:pobe_new/features/home/widgets/app_header.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfile();
    });
  }

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title akan hadir segera'),
        backgroundColor: const Color.fromRGBO(31, 54, 113, 1),
      ),
    );
  }

  Future<void> _handleCustomerService(ProfileViewModel vm) async {
    final success = await vm.openCustomerService();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
      );
    }
  }

  Future<void> _handleLogout(ProfileViewModel vm) async {
    await vm.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const colorPrimary = Color.fromRGBO(31, 54, 113, 1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ProfileViewModel>(
          builder: (context, vm, _) {
            return Column(
              children: [
                const PageHeader(title: 'Profile'),
                const SizedBox(height: 12),
                _ProfileHeader(
                  name: vm.displayName,
                  email: vm.profile?.email,
                  isLoading: vm.isLoading,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(209, 235, 254, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -160,
                          bottom: -60,
                          child: Opacity(
                            opacity: 1,
                            child: Image.asset(
                              'assets/stack/stack_elemen.png',
                              width: 340,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              // if (vm.error != null)
                              //   Padding(
                              //     padding:
                              //         const EdgeInsets.only(top: 12, bottom: 4),
                              //     child: _ErrorBanner(
                              //       message: vm.error!,
                              //       onRetry: vm.loadProfile,
                              //     ),
                              //   ),
                              const SizedBox(height: 16),
                              _ProfileActionTile(
                                icon: Icons.edit_outlined,
                                label: 'Edit Profile',
                                onTap: () => _showComingSoon('Edit profile'),
                              ),
                              _ProfileActionTile(
                                icon: Icons.settings_outlined,
                                label: 'Setting',
                                onTap: () => _showComingSoon('Setting'),
                              ),
                              _ProfileActionTile(
                                icon: Icons.support_agent_outlined,
                                label: 'Customer Service',
                                onTap: () => _handleCustomerService(vm),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorPrimary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: vm.isLoading
                                        ? null
                                        : () => _handleLogout(vm),
                                    icon: const Icon(Icons.logout_rounded,
                                        color: Colors.white),
                                    label: const Text(
                                      'Keluar',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20)
                            ],
                          ),
                        ),
                        if (vm.isLoading)
                          const Align(
                            alignment: Alignment.topCenter,
                            child: LinearProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    this.email,
    required this.isLoading,
  });

  final String name;
  final String? email;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorPrimary = const Color.fromRGBO(31, 54, 113, 1);

    return Column(
      children: [
        const CircleAvatar(
          radius: 44,
          backgroundColor: Color.fromRGBO(209, 235, 254, 1),
          backgroundImage: AssetImage('assets/logo/user.png'),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: TextStyle(
            color: colorPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (email != null && email!.isNotEmpty)
          Text(
            email!,
            style: TextStyle(
              color: colorPrimary.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        if (isLoading) const SizedBox(height: 8),
      ],
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color.fromRGBO(31, 54, 113, 1),
        ),
        title: Text(
          label,
          style: const TextStyle(
            color: Color.fromRGBO(31, 54, 113, 1),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
        trailing: const Icon(
          Icons.chevron_right,
          color: Color.fromRGBO(31, 54, 113, 1),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
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
