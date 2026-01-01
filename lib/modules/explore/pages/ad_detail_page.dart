import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/ad_model.dart';
import '../controllers/ad_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';

class AdDetailPage extends StatelessWidget {
  final AdModel ad;

  const AdDetailPage({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan CustomScrollView agar AppBar bisa menghilang saat di-scroll (Sliver)
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildMainInfo(),
                  const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
                  _buildAttributesSection(),
                  const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
                  _buildDescriptionSection(),
                  const SizedBox(height: 100), // Space untuk floating button
                ]),
              ),
            ],
          ),
          _buildBottomAction(context),
        ],
      ),
    );
  }

  // Header Gambar dengan Tombol Back
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      leading: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.3),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              itemCount: ad.images.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: ad.images[index].imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  // Placeholder saat loading
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  // Tampilan jika error (mencegah crash)
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                  // Optimasi memori: Resize gambar di memori (Penting untuk cegah OOM)
                  memCacheWidth: 1000,
                );
              },
            ),
            // Indikator Foto
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "1/${ad.images.length}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Info Harga dan Judul
  Widget _buildMainInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AdController.formatCurrency(ad.price),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF00AA5B),
            ),
          ),
          // Text(ad.user?.phone ?? ''),
          const SizedBox(height: 8),
          Text(
            ad.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                "${ad.province?.name}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Menampilkan Semua Attributes secara Dinamis
  Widget _buildAttributesSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detail Spesifikasi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 40,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: ad.attributes.length,
            itemBuilder: (context, index) {
              final attr = ad.attributes[index];
              return Row(
                children: [
                  _buildAttrIcon(attr.icon),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          attr.label,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          attr.value,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAttrIcon(String? url) {
    const double size = 24;
    const fallback = Icon(Icons.info_outline, size: size, color: Colors.grey);
    if (url == null) return fallback;

    return url.endsWith('.svg')
        ? SvgPicture.network(
            url,
            width: size,
            height: size,
            errorBuilder: (_, __, ___) => fallback,
          )
        : Image.network(
            url,
            width: size,
            height: size,
            errorBuilder: (_, __, ___) => fallback,
          );
  }

  // Deskripsi
  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Deskripsi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Html(
            data: ad.description ?? "Tidak ada deskripsi",
            style: {
              "body": Style(
                fontSize: FontSize(14.0),
                color: Colors.black87,
                lineHeight: LineHeight(1.5),
                margin: Margins.zero,
                padding: HtmlPaddings.symmetric(horizontal: 8),
              ),
              "p": Style(margin: Margins.only(bottom: 10)),
              "strong": Style(fontWeight: FontWeight.bold),
            },
          ),
        ],
      ),
    );
  }

  // Sticky Button di bawah (Chat / WhatsApp)
  Widget _buildBottomAction(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00AA5B)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.chat_outlined, color: Color(0xFF00AA5B)),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AA5B),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Hubungi Penjual",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
