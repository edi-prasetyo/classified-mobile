// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:property/core/widgets/button.dart';

// import '../controllers/detail_controller.dart';

// class PropertyDetailPage extends ConsumerWidget {
//   final int propertyId;
//   const PropertyDetailPage({super.key, required this.propertyId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final property = ref.watch(selectedPropertyProvider(propertyId));

//     if (property == null) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: GradientButtonDanger(
//             text: 'Schedule Appointment',
//             onPressed: () {},
//           ),
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 240,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   CachedNetworkImage(
//                     imageUrl: property.imageUrl,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) =>
//                         const Center(child: CircularProgressIndicator()),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.broken_image),
//                   ),
//                   const Positioned(
//                     top: 40,
//                     right: 16,
//                     child: Icon(Icons.favorite_border, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             leading: const BackButton(color: Colors.black),
//             backgroundColor: Colors.white,
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     property.title,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on_outlined,
//                         size: 16,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         property.location,
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       const Icon(Icons.king_bed_outlined, size: 20),
//                       const SizedBox(width: 4),
//                       Text('${property.bedrooms} Beds'),
//                       const SizedBox(width: 16),
//                       const Icon(Icons.bathtub_outlined, size: 20),
//                       const SizedBox(width: 4),
//                       Text('${property.bathrooms} Bath'),
//                     ],
//                   ),
//                   const Divider(height: 32),
//                   const Text(
//                     'Listing Agent',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       const CircleAvatar(
//                         radius: 24,
//                         backgroundImage: CachedNetworkImageProvider(
//                           'https://randomuser.me/api/portraits/men/10.jpg',
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'John Ronaldo',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               'Partner',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(Icons.message_outlined),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(Icons.call_outlined),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   const Text(
//                     'Overview',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Deskripsi properti singkat bisa ditambahkan di sini. '
//                     'Informasi lebih lanjut seperti ukuran, fasilitas tambahan, dll.',
//                     style: TextStyle(color: Colors.black87, height: 1.5),
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       Text(
//                         'Photos',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         'See All',
//                         style: TextStyle(color: Colors.blueAccent),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     height: 90,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 3,
//                       itemBuilder: (context, index) => Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: CachedNetworkImage(
//                             imageUrl:
//                                 'https://picsum.photos/seed/${index + 11}/200/200',
//                             width: 120,
//                             height: 90,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => const Center(
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             ),
//                             errorWidget: (context, url, error) =>
//                                 const Icon(Icons.broken_image),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
