import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../modules/categories/cotrollers/category_controller.dart';
import '../../modules/home/widgets/city_search_page.dart';
import 'button_solid.dart';

class SearchFilterBottomSheet extends ConsumerStatefulWidget {
  final void Function(Map<String, dynamic> filterValues)? onApply;

  const SearchFilterBottomSheet({super.key, this.onApply});

  @override
  ConsumerState<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState
    extends ConsumerState<SearchFilterBottomSheet> {
  final TextEditingController cityController = TextEditingController();

  final double _minPrice = 10000000;
  final double _maxPrice = 100000000000;
  RangeValues _priceRange = const RangeValues(10000000, 100000000000);

  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final List<String> _statuses = ['Sewa', 'Jual'];

  String? _selectedType;
  String? _selectedStatus;
  String? _selectedCertificate;

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoryControllerProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Filter Pencarian',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // City (Full Screen Autocomplete)
            GestureDetector(
              onTap: () async {
                final selectedCity = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CitySearchPage()),
                );

                if (selectedCity != null) {
                  setState(() {
                    cityController.text = selectedCity.name; // simpan nama kota
                  });
                }
              },
              child: AbsorbPointer(
                child: _buildTextField(
                  controller: cityController,
                  label: 'City',
                  hint: 'Pilih kota',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Type Chips (from API)
            categoriesState.when(
              data: (categories) {
                return _buildChoiceChips(
                  'Type',
                  categories.map((c) => c.name).toList(),
                  _selectedType,
                  (val) => setState(() => _selectedType = val),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 12),

            // Status Chips
            _buildChoiceChips('Status', _statuses, _selectedStatus, (val) {
              setState(() => _selectedStatus = val);
            }),
            const SizedBox(height: 12),

            // Price Range
            const Text(
              'Price Range',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '${currencyFormatter.format(_priceRange.start)} - ${currencyFormatter.format(_priceRange.end)}',
              style: const TextStyle(color: Colors.grey),
            ),
            RangeSlider(
              values: _priceRange,
              min: _minPrice,
              max: _maxPrice,
              divisions: 100,
              labels: RangeLabels(
                currencyFormatter.format(_priceRange.start),
                currencyFormatter.format(_priceRange.end),
              ),
              onChanged: (values) {
                setState(() => _priceRange = values);
              },
            ),
            const SizedBox(height: 20),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Apply Filter",
                // loading: true,
                onPressed: () {
                  final filterValues = {
                    'city': cityController.text,
                    'type': _selectedType,
                    'status': _selectedStatus,
                    'certificate': _selectedCertificate,
                    'minPrice': _priceRange.start.toInt(),
                    'maxPrice': _priceRange.end.toInt(),
                  };
                  if (widget.onApply != null) widget.onApply!(filterValues);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildChoiceChips(
    String label,
    List<String> options,
    String? selectedValue,
    Function(String) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((option) {
            final bool isSelected = selectedValue == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
              selectedColor: AppColors.primaryColor,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
