import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/ad_card_widget.dart';
import '../controllers/ad_controller.dart';
import '../widgets/filter_widget.dart';

class AdPage extends ConsumerWidget {
  const AdPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsAsync = ref.watch(adControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Telusuri Iklan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // FILTER BAR
          _buildFilterBar(context),

          // LIST IKLAN
          Expanded(
            child: adsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF00AA5B)),
              ),
              error: (err, stack) =>
                  Center(child: Text("Terjadi kesalahan: $err")),
              data: (ads) {
                if (ads.isEmpty) {
                  return _buildEmptyState();
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    // RESPONSIVE SETTING
                    int crossAxisCount = 2;
                    double aspectRatio = 0.73;

                    if (constraints.maxWidth >= 900) {
                      // Tablet besar
                      crossAxisCount = 4;
                      aspectRatio = 0.85;
                    } else if (constraints.maxWidth >= 600) {
                      // Tablet
                      crossAxisCount = 3;
                      aspectRatio = 0.85;
                    }

                    return RefreshIndicator(
                      onRefresh: () => ref.refresh(adControllerProvider.future),
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: ads.length,
                        itemBuilder: (context, index) {
                          final ad = ads[index];

                          return AdCardWidget(
                            ad: ad,
                            isTablet: constraints.maxWidth >= 600,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _filterChip(
            label: "Filter",
            icon: Icons.tune,
            isSelected: true,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const FilterWidget(),
              );
            },
          ),
          const VerticalDivider(width: 20, indent: 5, endIndent: 5),
          _filterChip(label: "Sewa", onPressed: () {}),
          _filterChip(label: "Jual", onPressed: () {}),
          _filterChip(label: "Terdekat", onPressed: () {}),
          _filterChip(label: "Harga Terendah", onPressed: () {}),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    IconData? icon,
    bool isSelected = false,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        onPressed: onPressed,
        elevation: 0,
        pressElevation: 0,
        backgroundColor: isSelected ? const Color(0xFFE6F6EC) : Colors.white,
        side: BorderSide(
          color: isSelected ? const Color(0xFF00AA5B) : Colors.grey.shade300,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        label: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? const Color(0xFF00AA5B) : Colors.black,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF00AA5B) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.ads_click, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "Belum ada iklan tersedia",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
