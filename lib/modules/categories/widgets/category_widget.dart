import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../controllers/category_controller.dart'; // Sesuaikan path controller Anda
import 'package:flutter_svg/flutter_svg.dart';

class CategoryWidget extends ConsumerWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Membaca state dari AsyncNotifierProvider
    final categoryAsync = ref.watch(categoryControllerProvider);

    return categoryAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: Color(0xFF00AA5B)),
        ),
      ),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text("Gagal memuat kategori: $err"),
        ),
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(child: Text("Kategori kosong"));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: categories.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = categories[index];
            final hasChildren =
                item.children != null && item.children!.isNotEmpty;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: _buildIcon(item),
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                  trailing: hasChildren
                      ? const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                        )
                      : const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                        ),
                  children: [
                    if (hasChildren)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 56,
                          right: 16,
                          bottom: 12,
                        ),
                        child: Column(
                          children: item.children!
                              .map((child) => _buildChildItem(child, context))
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChildItem(CategoryModel child, BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, child.route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Row(
          children: [
            Text(
              child.name,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6D6D6D),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(CategoryModel item) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: item.image != null && item.image!.isNotEmpty
          ? SvgPicture.network(
              item.image!,
              colorFilter: const ColorFilter.mode(
                Color(0xFF00AA5B),
                BlendMode.srcIn,
              ),
              fit: BoxFit.contain,
              placeholderBuilder: (context) => const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : const Icon(
              Icons.category_rounded,
              color: Color(0xFF00AA5B),
              size: 20,
            ),
    );
  }
}
