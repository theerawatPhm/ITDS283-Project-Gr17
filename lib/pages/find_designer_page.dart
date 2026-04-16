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
      'specialty': 'Character & Organic Sculpting',
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

class DesignerProfilePage extends StatelessWidget {
  final Map<String, dynamic> designerData;
  const DesignerProfilePage({super.key, required this.designerData});

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = const Color(0xFF4A3B52);
    final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
    final Color bgColor = const Color(0xFFF8F8F8);

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
          'Designer Profile',
          style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryOrange, width: 2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      designerData['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          Icon(Icons.person, size: 60, color: Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(designerData['name'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryDark)),
                  Text(designerData['specialty'], style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryDark)),
                        const SizedBox(height: 8),
                        Text(
                          'Expert designer dedicated to high-quality 3D modeling and innovation. Let\'s make your vision a reality.',
                          style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 14),
                        ),
                        const Divider(height: 30),
                        _buildDetailRow('Rating:', designerData['rating'], primaryDark),
                        _buildDetailRow('Starting Price:', designerData['price'], primaryDark),
                        _buildDetailRow('Contact:', '${designerData['name'].toString().toLowerCase().replaceAll(' ', '')}@3dnow.com', primaryDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(color: bgColor),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewOrderPage(
                        
                        fileName: 'Hire: ${designerData['name']}',
                        fileSize: '-',
                        material: 'Discuss with designer',
                        quality: 'High',
                        scrub: 'No',
                        color: '-',
                        requestFile: 'Yes',
                        otherText: 'Starting Price: ${designerData['price']}',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                ),
                child: const Text(
                  'Hire This Designer',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color primaryDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: primaryDark, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}