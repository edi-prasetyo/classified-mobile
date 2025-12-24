import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/globals/controllers/city_controller.dart';
import '../../../core/globals/models/city_model.dart';

class CitySearchPage extends ConsumerStatefulWidget {
  const CitySearchPage({super.key});

  @override
  ConsumerState<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends ConsumerState<CitySearchPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      ref
          .read(cityControllerProvider.notifier)
          .searchCities(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari kota...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: state.when(
        data: (cities) {
          if (cities.isEmpty) {
            return const Center(child: Text("Tidak ada hasil"));
          }
          return ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final CityModel city = cities[index];
              return ListTile(
                title: Text(city.name),
                subtitle: Text(city.provinceName),
                onTap: () {
                  Navigator.pop(context, city);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
