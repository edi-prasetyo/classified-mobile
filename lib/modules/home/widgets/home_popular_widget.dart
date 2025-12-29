import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/ad_card_widget.dart';
import '../../explore/controllers/ad_controller.dart';
import '../../explore/models/ad_model.dart';

class HomePopularWidget extends ConsumerStatefulWidget {
  const HomePopularWidget({super.key});

  @override
  ConsumerState<HomePopularWidget> createState() => _HomePopularWidgetState();
}

class _HomePopularWidgetState extends ConsumerState<HomePopularWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.78);
  int _currentIndex = 0;

  bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final adsAsync = ref.watch(adControllerProvider);

    return adsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Gagal memuat iklan populer: $e'),
      ),
      data: (_) {
        return FutureBuilder<List<AdModel>>(
          future: ref.read(adControllerProvider.notifier).fetchPopularAds(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Belum ada iklan populer'),
              );
            }

            final ads = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Iklan Populer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 12),

                /// SLIDER
                SizedBox(
                  height: isTablet ? 850 : 350,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: ads.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: AdCardWidget(
                          ad: ads[index],
                          width: isTablet ? 260 : 200,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                /// DOT INDICATOR
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      ads.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _currentIndex == index
                              ? const Color(0xFF00AA5B)
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
