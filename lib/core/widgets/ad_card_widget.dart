import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../modules/explore/controllers/ad_controller.dart';
import '../../modules/explore/models/ad_model.dart';
import '../../modules/explore/pages/ad_detail_page.dart';
import '../constants/colors.dart';

class AdCardWidget extends StatelessWidget {
  final AdModel ad;
  final bool isHorizontal;
  final bool isTablet;
  final double? width;

  const AdCardWidget({
    super.key,
    required this.ad,
    this.isHorizontal = false,
    this.isTablet = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final AdImage? primaryImage = ad.images.isNotEmpty
        ? ad.images.firstWhere(
            (img) => img.isPrimary == 1,
            orElse: () => ad.images.first,
          )
        : null;

    return SizedBox(
      width: width,
      child: Card(
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
              MaterialPageRoute(builder: (_) => AdDetailPage(ad: ad)),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(primaryImage?.imageThumbUrl),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 14 : 13,
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

                    // ATRIBUT
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
      ),
    );
  }

  Widget _buildImageSection(String? imageUrl) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        children: [
          imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageFallback(),
                )
              : _imageFallback(),

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
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 10, color: Colors.grey),
        const SizedBox(width: 2),
        Expanded(
          child: Text(
            ad.regency?.name ?? '',
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

    if (iconUrl == null ||
        iconUrl.isEmpty ||
        !iconUrl.toLowerCase().endsWith('.svg')) {
      return const Icon(Icons.circle, size: iconSize, color: Colors.grey);
    }

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: SvgPicture.network(
        iconUrl,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
      ),
    );
  }
}
