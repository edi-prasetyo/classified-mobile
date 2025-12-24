import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../models/ad_model.dart';
import '../controllers/ad_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../pages/ad_detail_page.dart';

class AdCardWidget extends StatelessWidget {
  final AdModel ad;
  const AdCardWidget({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    final primaryImage = ad.images.firstWhere(
      (img) => img.isPrimary == 1,
      orElse: () => ad.images.first,
    );

    return Card(
      color: AppColors.whiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdDetailPage(ad: ad)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(primaryImage.imageThumbUrl),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AdController.formatCurrency(ad.price),
                    style: const TextStyle(
                      color: Color(0xFF00AA5B),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // SEKSI ATRIBUT (BBM, Tahun, dll)
                  if (ad.attributes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: ad.attributes.take(2).map((attr) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // IKON DINAMIS DENGAN FALLBACK UNIVERSAL
                                _buildDynamicIcon(attr.icon),
                                const SizedBox(width: 4),
                                Text(
                                  attr.value,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  _buildLocationInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(String imageUrl) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) =>
              Container(height: 120, color: Colors.grey.shade100),
        ),
        Positioned(
          top: 6,
          left: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: ad.adStatus == 'rent'
                  ? Colors.blue.shade700
                  : Colors.orange.shade800,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              ad.adStatus == 'rent' ? 'SEWA' : 'JUAL',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 10, color: Colors.grey),
        const SizedBox(width: 2),
        Expanded(
          child: Text(
            "${ad.regency?.name ?? ''}",
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicIcon(String? iconUrl) {
    const double iconSize = 10.0;

    // Ikon default universal jika URL error atau null
    const defaultIcon = Icon(
      Icons.lens_blur_rounded, // Ikon titik/bullet yang elegan dan netral
      size: iconSize,
      color: Colors.grey,
    );

    if (iconUrl == null || iconUrl.isEmpty) return defaultIcon;

    // Cek apakah file SVG (sesuai format API Anda)
    final isSvg = iconUrl.toLowerCase().endsWith('.svg');

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: isSvg
          ? SvgPicture.network(
              iconUrl,
              colorFilter: ColorFilter.mode(
                Colors.grey.shade600,
                BlendMode.srcIn,
              ),
              placeholderBuilder: (_) => defaultIcon,
              errorBuilder: (_, __, ___) => defaultIcon,
            )
          : Image.network(iconUrl, errorBuilder: (_, __, ___) => defaultIcon),
    );
  }
}
