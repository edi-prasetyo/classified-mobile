import 'package:flutter/material.dart';
import '../widgets/category_widget.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key}); // Constructor kosong, navigasi aman!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Semua Kategori",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // Cukup panggil tanpa kirim data
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}
