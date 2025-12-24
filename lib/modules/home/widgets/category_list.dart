import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../categories/cotrollers/category_controller.dart';
import '../../categories/models/category_model.dart';
import '../../categories/pages/category_page.dart';

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoryControllerProvider);

    return categoriesState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text("Error: $error")),
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(child: Text("No categories found"));
        }

        // ambil hanya 5 kategori pertama
        final limitedCategories = categories.take(5).toList();

        // tambah kategori statis "Lihat Semua"
        final allCategories = [
          ...limitedCategories,
          CategoryModel(
            id: 0,
            name: "Lihat Semua",
            slug: "all",
            image: null,
            route: "all",
            parentId: null,
          ),
        ];

        return GridView.count(
          physics:
              const NeverScrollableScrollPhysics(), // jangan scroll sendiri
          shrinkWrap: true, // biar ikut tinggi konten
          crossAxisCount: 3,
          childAspectRatio: 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          padding: const EdgeInsets.all(16),
          children: allCategories.map((category) {
            final isStatic = category.id == 0;
            return GestureDetector(
              onTap: () {
                if (isStatic) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryPage()),
                  );
                } else {
                  debugPrint("Clicked ${category.name}");
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    child: isStatic
                        ? const Icon(
                            Icons.arrow_forward,
                            color: Colors.black54,
                            size: 28,
                          )
                        : (category.image != null
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: category.image!,
                                    fit: BoxFit.cover,
                                    width: 20,
                                    height: 20,
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.category,
                                          color: Colors.black54,
                                        ),
                                  ),
                                )
                              : const Icon(
                                  Icons.category,
                                  color: Colors.black54,
                                )),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
