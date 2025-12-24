// // modules/detail/controllers/detail_controller.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../models/property_model.dart';
// import '../../home/controllers/home_controller.dart'; // penting!

// final selectedPropertyProvider = Provider.family<PropertyModel?, int>((
//   ref,
//   id,
// ) {
//   final list = ref.watch(homeControllerProvider).value;
//   if (list == null) return null;

//   for (final item in list) {
//     if (item.id == id) return item;
//   }
//   return null;
// });
