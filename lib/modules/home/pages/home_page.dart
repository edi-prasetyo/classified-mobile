import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/home_category_widget.dart';
import '../widgets/home_latest_ads_widget.dart';
import '../widgets/home_popular_widget.dart';

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
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isTablet = width >= 600;

              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 32 : 0,
                    ),
                    child: Column(
                      children: [
                        const HomeHeader(),
                        SizedBox(height: isTablet ? 32 : 24),
                        HomeCategoryWidget(categories: categories),
                        SizedBox(height: isTablet ? 32 : 24),
                        const HomePopularWidget(),
                        SizedBox(height: isTablet ? 32 : 24),
                        const HomeLatestAdsWidget(),
                        SizedBox(height: isTablet ? 32 : 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
