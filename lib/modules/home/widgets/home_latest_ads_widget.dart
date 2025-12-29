import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/ad_card_widget.dart';
import '../../explore/controllers/ad_controller.dart';
import '../../explore/pages/ad_page.dart';

class HomeLatestAdsWidget extends ConsumerWidget {
  const HomeLatestAdsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsAsync = ref.watch(adControllerProvider);

    return adsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Gagal memuat iklan terbaru'),
      ),
      data: (ads) {
        final latestAds = ads.take(8).toList();

        if (latestAds.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Belum ada iklan terbaru'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Iklan Terbaru',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdPage()),
                      );
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00AA5B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 2;
                double aspectRatio = 0.73;
                bool isTablet = false;

                if (constraints.maxWidth >= 900) {
                  crossAxisCount = 4;
                  aspectRatio = 0.85;
                  isTablet = true;
                } else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 3;
                  aspectRatio = 0.85;
                  isTablet = true;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: latestAds.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    return AdCardWidget(
                      ad: latestAds[index],
                      isTablet: isTablet,
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
