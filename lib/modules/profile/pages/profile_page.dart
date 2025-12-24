import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

import '../../../core/constants/colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../main_navigation.dart';
import '../../auth/controllers/user_controller.dart';
import '../../auth/pages/login_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _loading = true;
  bool _loggedIn = false;
  String _appVersion = "";

  @override
  void initState() {
    super.initState();
    _checkLogin();
    _loadAppVersion();
  }

  Future<void> _checkLogin() async {
    final isLogin = await AuthService.isLoggedIn();
    if (!isLogin && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      setState(() {
        _loggedIn = true;
        _loading = false;
      });

      Future.microtask(() {
        ref.read(userControllerProvider.notifier).getMyProfile();
      });
    }
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${info.version} ";
    });
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 0)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_loggedIn) {
      return const SizedBox();
    }

    final user = userState.user;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      // appBar: AppBar(title: const Text("Profil")),
      body: userState.loading
          ? const Center(child: CircularProgressIndicator())
          : userState.error != null
          ? Center(child: Text(userState.error!))
          : user == null
          ? const Center(child: Text("Tidak ada data"))
          : Column(
              children: [
                // Header user
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green.shade600,
                        child: Text(
                          (user.name.isNotEmpty == true ? user.name[0] : "U")
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.phone,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Menu list
                Expanded(
                  child: ListView(
                    children: [
                      _buildMenuItem(
                        icon: MingCuteIcons.mgc_user_edit_line,
                        title: "Edit Profile",
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: MingCuteIcons.mgc_lock_line,
                        title: "Ubah Password",
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: MingCuteIcons.mgc_notification_line,
                        title: "Seting Notifikasi",
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: MingCuteIcons.mgc_document_line,
                        title: "Kebijakan Privasi",
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: MingCuteIcons.mgc_file_check_line,
                        title: "Syarat & Ketentuan",
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: MingCuteIcons.mgc_headphone_2_line,
                        title: "Hubungi Kami",
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: MingCuteIcons.mgc_star_line,
                        title: "Beri Rating",
                        onTap: () {},
                      ),

                      const SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              "Versi aplikasi: $_appVersion",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _logout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.logout),
                              label: const Text("Logout"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Versi + Logout
              ],
            ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primaryTextColorGrey),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(
          height: 1,
          indent: 50,
          endIndent: 16,
          color: AppColors.backgroundColorGrey,
        ),
      ],
    );
  }
}
