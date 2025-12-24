import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  // State sederhana untuk simulasi pemilihan
  String _selectedType = "Semua";
  String _selectedSort = "Terbaru";

  @override
  Widget build(BuildContext context) {
    return Container(
      // Menyesuaikan tinggi dengan keyboard jika input harga aktif
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar (Indikator geser)
          _buildHandleBar(),

          // Header Filter
          _buildHeader(context),
          const Divider(height: 1),

          // Konten Filter (Scrollable)
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Tipe Iklan"),
                  _buildChoiceChips(
                    ["Semua", "Disewakan", "Dijual"],
                    _selectedType,
                    (val) => setState(() => _selectedType = val),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle("Rentang Harga (Rp)"),
                  Row(
                    children: [
                      Expanded(child: _buildPriceField("Minimum")),
                      const SizedBox(width: 12),
                      Expanded(child: _buildPriceField("Maksimum")),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle("Urutkan Berdasarkan"),
                  _buildChoiceChips(
                    [
                      "Terbaru",
                      "Terdekat",
                      "Harga Terendah",
                      "Harga Tertinggi",
                    ],
                    _selectedSort,
                    (val) => setState(() => _selectedSort = val),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Tombol Aksi Sticky
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 10, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Filter Iklan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedType = "Semua";
                _selectedSort = "Terbaru";
              });
            },
            child: const Text(
              "Reset",
              style: TextStyle(
                color: Color(0xFF00AA5B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildChoiceChips(
    List<String> options,
    String selectedValue,
    Function(String) onSelected,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) => onSelected(option),
          selectedColor: const Color(0xFFE6F6EC),
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? const Color(0xFF00AA5B) : Colors.black87,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? const Color(0xFF00AA5B) : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  Widget _buildPriceField(String hint) {
    return TextField(
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        prefixText: "Rp ",
        prefixStyle: const TextStyle(color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF00AA5B)),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00AA5B),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Tampilkan Hasil",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
