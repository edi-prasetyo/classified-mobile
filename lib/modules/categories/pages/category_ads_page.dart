import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/ad_card_widget.dart';
import '../controllers/category_controller.dart';

class CategoryAdsPage extends ConsumerWidget {
  final String categoryName;
  final String categorySlug;

  const CategoryAdsPage({
    super.key,
    required this.categoryName,
    required this.categorySlug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsAsync = ref.watch(categoryAdsProvider(categorySlug));

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: adsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (ads) {
          if (ads.isEmpty) {
            return const Center(child: Text('Belum ada iklan di kategori ini'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // RESPONSIVE SETTING
              int crossAxisCount = 2;
              double aspectRatio = 0.73;
              bool isTablet = false;

              if (constraints.maxWidth >= 900) {
                // Tablet besar
                crossAxisCount = 4;
                aspectRatio = 0.85;
                isTablet = true;
              } else if (constraints.maxWidth >= 600) {
                // Tablet
                crossAxisCount = 3;
                aspectRatio = 0.85;
                isTablet = true;
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  return AdCardWidget(
                    ad: ads[index],
                    isTablet: isTablet, // 🔥 PENTING
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
