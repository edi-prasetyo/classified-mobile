import 'package:flutter/material.dart';
import '../../categories/models/category_model.dart';
import '../../categories/pages/category_page.dart';

class HomeCategoryWidget extends StatelessWidget {
  final List<CategoryModel> categories;

  const HomeCategoryWidget({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    // Menambahkan 1 untuk kartu statis "More"
    final int itemCount = categories.length + 1;

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
            crossAxisCount: 4, // 4 Kolom per baris
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
            childAspectRatio:
                0.8, // Mengatur tinggi agar pas untuk layout vertikal
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // Cek apakah ini item terakhir (Kartu More)
            if (index == categories.length) {
              return _buildCategoryItem(
                context,
                title: "Lainnya",
                icon: Icons.grid_view_rounded,
                iconColor: Colors.grey.shade700,
                bgColor: Colors.grey.shade100,
                onTap: () {
                  // Navigasi ke halaman semua kategori
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryPage(),
                    ),
                  );
                },
              );
            }

            final category = categories[index];
            return _buildCategoryItem(
              context,
              title: category.name,
              icon: _getIconForCategory(category.slug),
              iconColor: Colors.blueAccent,
              bgColor: Colors.blueAccent.withOpacity(0.1),
              onTap: () {
                print("Navigasi ke: ${category.route}");
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Icon Container (Lingkaran/Rounded Box)
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              // Shadow halus agar terlihat modern di 2025
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          // Judul Kategori
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

  IconData _getIconForCategory(String slug) {
    switch (slug) {
      case 'property':
        return Icons.home_work_rounded;
      case 'kendaraan':
        return Icons.directions_car_filled_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
