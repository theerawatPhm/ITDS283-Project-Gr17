import 'package:flutter/material.dart';
import 'review_order_page.dart';

class FindDesignerPage extends StatefulWidget {
  const FindDesignerPage({super.key});

  @override
  State<FindDesignerPage> createState() => _FindDesignerPageState();
}

class _FindDesignerPageState extends State<FindDesignerPage> {
  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);

  final List<Map<String, dynamic>> mockDesigners = [
    {
      'name': 'Theerawat',
      'specialty': 'Mechanical & Hard Surface Expert',
      'rating': '4.9 (150 reviews)',
      'price': 'Starts at ฿500',
      'image': 'assets/img/designer_1.jpg', 
    },
    {
      'name': 'Proudrawee',
      'specialty': 'Product and Medical models design.',
      'rating': '4.8 (92 reviews)',
      'price': 'Starts at ฿850',
      'image': 'assets/img/designer_2.jpg',
    },
    {
      'name': 'Baipor',
      'specialty': 'Architecture & Landscape Modeling',
      'rating': '4.6 (210 reviews)',
      'price': 'Starts at ฿1,200',
      'image': 'assets/img/designer_3.jpg',
    },
    {
      'name': 'Amika C.',
      'specialty': 'Jewelry & Accessory Design',
      'rating': '4.5 (58 reviews)',
      'price': 'Starts at ฿450',
      'image': 'assets/img/designer_4.jpg',
    },
    {
      'name': 'Mynn',
      'specialty': 'Product Design & Rendering',
      'rating': '4.8 (115 reviews)',
      'price': 'Starts at ฿600',
      'image': 'assets/img/designer_5.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryDark, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Find Designer',
          style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: primaryDark, width: 1.5),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 8, top: 5, bottom: 5),
                    child: Icon(Icons.search, color: Color(0xFF4A3B52), size: 28),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search designer...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text('Enter', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              itemCount: mockDesigners.length,
              itemBuilder: (context, index) {
                final designer = mockDesigners[index];
                return _buildDesignerCard(designer);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignerCard(Map<String, dynamic> designer) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DesignerProfilePage(designerData: designer),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                designer['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    Icon(Icons.person, size: 40, color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    designer['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(designer['specialty'], style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(designer['rating'], style: TextStyle(color: primaryDark, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    designer['price'],
                    style: TextStyle(color: primaryOrange, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// หน้า Designer Profile

class DesignerProfilePage extends StatefulWidget {
  final Map<String, dynamic> designerData;
  const DesignerProfilePage({super.key, required this.designerData});

  @override
  State<DesignerProfilePage> createState() => _DesignerProfilePageState();
}

class _DesignerProfilePageState extends State<DesignerProfilePage> {
  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);

  // ตัวแปรสำหรับเก็บข้อมูลฟอร์ม
  final TextEditingController _describeController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _selectedMaterial = 'PLA';
  String _selectedQuality = 'Low';
  String _selectedScrub = 'Yes';
  String _selectedColor = 'Filament Color';
  String _selectedRequestFile = 'Yes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryDark, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Find Designer',
          style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. designer info ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    widget.designerData['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.person, size: 50, color: Colors.grey.shade400),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.designerData['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDark)),
                      const SizedBox(height: 4),
                      Text(widget.designerData['specialty'], style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      const SizedBox(height: 8),
                      Text('Software: Blender, MAYA\nAVG work time: 1-2 days', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('Read CV >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryDark)),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 2. Describe your need design ---
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryOrange.withOpacity(0.5)),
              ),
              child: TextField(
                controller: _describeController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Describe your\nneed design...',
                  hintStyle: TextStyle(color: primaryOrange.withOpacity(0.6), fontSize: 14),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            
            // Clear & Submit button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _describeController.clear();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryOrange,
                    side: BorderSide(color: primaryOrange.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(60, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Clear', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(60, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    elevation: 0,
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- 3. Input Model Detail ---
            Text('Input Model Detail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark)),
            const SizedBox(height: 16),
            
            _buildOptionRow(title: 'Material', options: ['PLA', 'TPU', 'ABS'], currentValue: _selectedMaterial, onChanged: (val) => setState(() => _selectedMaterial = val)),
            const SizedBox(height: 12),
            _buildOptionRow(title: 'Quality', options: ['Low', 'Mid', 'High'], currentValue: _selectedQuality, onChanged: (val) => setState(() => _selectedQuality = val)),
            const SizedBox(height: 12),
            _buildOptionRow(title: 'Scrub', options: ['Yes', 'No'], currentValue: _selectedScrub, onChanged: (val) => setState(() => _selectedScrub = val)),
            const SizedBox(height: 12),
            _buildOptionRow(title: 'Color', options: ['Filament Color', 'Spray Color'], currentValue: _selectedColor, onChanged: (val) => setState(() => _selectedColor = val)),
            const SizedBox(height: 12),
            _buildOptionRow(title: 'Request File', options: ['Yes', 'No'], currentValue: _selectedRequestFile, onChanged: (val) => setState(() => _selectedRequestFile = val)),
            const SizedBox(height: 12),
            
            // Other
            Row(
              children: [
                SizedBox(width: 80, child: Text('Other', style: TextStyle(color: primaryDark, fontSize: 14))),
                Expanded(
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _otherController,
                      decoration: const InputDecoration(
                        hintText: 'optional...',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.only(bottom: 12),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),

            // --- 4. Delivery Information ---
            Text('Delivery Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark)),
            const SizedBox(height: 12),
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Center(
                child: TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Place your location',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Delivery Fee: ฿60', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ),
            const SizedBox(height: 24),

            // --- 5. ปุ่ม Next ---
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // go to Review Order
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewOrderPage(
                        designerDescription: _describeController.text.isEmpty ? "Hire: ${widget.designerData['name']}" : _describeController.text,
                    
                        material: _selectedMaterial,
                        quality: _selectedQuality,
                        scrub: _selectedScrub,
                        color: _selectedColor,
                        requestFile: _selectedRequestFile,
                        otherText: _otherController.text.isEmpty ? 'None' : _otherController.text,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text('Next >', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget สร้างปุ่มตัวเลือก
  Widget _buildOptionRow({
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(title, style: TextStyle(color: primaryDark, fontSize: 14)),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = currentValue == option;
              return GestureDetector(
                onTap: () => onChanged(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.transparent : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? primaryDark : Colors.grey.shade400,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? primaryDark : Colors.grey.shade600,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}