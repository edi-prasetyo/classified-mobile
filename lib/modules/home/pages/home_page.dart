import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/home_controller.dart';
import '../widgets/home_header.dart';

import '../widgets/home_category_widget.dart'; // Import widget baru

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCategories = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: asyncCategories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat data: $e')),
        data: (categories) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 24),
                  // Menggunakan widget yang baru dibuat
                  HomeCategoryWidget(categories: categories),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
