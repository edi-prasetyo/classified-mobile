import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../categories/models/category_model.dart';
import '../../categories/pages/category_page.dart';

class HomeCategoryWidget extends StatelessWidget {
  final List<CategoryModel> categories;

  const HomeCategoryWidget({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    // 🔒 Ambil maksimal 3 kategori
    final List<CategoryModel> visibleCategories = categories.take(3).toList();

    // +1 untuk kartu statis "Lainnya"
    final int itemCount = visibleCategories.length + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Text(
            "Kategori",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // 🟩 Kartu statis "Lainnya" (selalu terakhir)
            if (index == visibleCategories.length) {
              return _buildCategoryItem(
                title: "Lainnya",
                bgColor: Colors.blueAccent.withAlpha((255 * 0.1).round()),
                icon: const Icon(
                  Icons.grid_view_rounded,
                  size: 28,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryPage()),
                  );
                },
              );
            }

            final category = visibleCategories[index];

            return _buildCategoryItem(
              title: category.name,
              bgColor: Colors.blueAccent.withOpacity(0.1),
              icon: _buildSafeCategoryIcon(category),
              onTap: () {
                debugPrint("Navigasi ke: ${category.route}");
              },
            );
          },
        ),
      ],
    );
  }

  // =========================
  // ITEM UI
  // =========================
  Widget _buildCategoryItem({
    required String title,
    required Widget icon,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // =========================
  // SAFE ICON BUILDER
  // =========================
  Widget _buildSafeCategoryIcon(CategoryModel category) {
    final image = category.image;

    // 1️⃣ Kosong → fallback
    if (image == null || image.isEmpty) {
      return const Icon(
        Icons.category_rounded,
        size: 28,
        color: Colors.blueAccent,
      );
    }

    // 2️⃣ SVG
    if (image.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        image,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
        colorFilter: const ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn),
        placeholderBuilder: (_) => const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    // 3️⃣ PNG / JPG / format lain
    return Image.network(
      image,
      width: 28,
      height: 28,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        return const Icon(
          Icons.category_rounded,
          size: 28,
          color: Colors.blueAccent,
        );
      },
    );
  }
}
