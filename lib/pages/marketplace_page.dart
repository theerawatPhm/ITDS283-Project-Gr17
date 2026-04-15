import 'package:app_3d_now/pages/add_model_page.dart';
import 'package:flutter/material.dart';
import 'find_store_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);

  final TextEditingController _searchController = TextEditingController();
  String _userRole = 'customer';
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && mounted) {
        setState(() {
          _userRole = userDoc.get('role') ?? 'customer';
        });
      }
    }
  }

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
          'Find Model',
          style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      floatingActionButton: _userRole == 'designer'
          ? FloatingActionButton(
              backgroundColor: primaryOrange,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.add, color: Colors.white, size: 30,),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddModelPage()));
              })
          : null,
      body: Column(
        children: [
          //search box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: primaryOrange, width: 1.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _searchKeyword = value.toLowerCase()), 
                      decoration: InputDecoration(
                        hintText: 'Search for models...',
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16,),
                        prefixIcon: Icon(Icons.search, color: primaryOrange,),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          //pull from fireBase
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('app3dnow_marketplace')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: primaryOrange));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('No models available', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                      ],
                    ),
                  );
                }

                // Firebase to list
                final allModels = snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return data;
                }).toList();

                //กรองข้อมูลตามที่ Search
                final filteredModels = _searchKeyword.isEmpty
                    ? allModels
                    : allModels.where((model) => 
                        (model['title'] ?? '').toString().toLowerCase().contains(_searchKeyword)).toList();

                if (filteredModels.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('No results found', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredModels.length,
                  itemBuilder: (context, index) {
                    final model = filteredModels[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModelPreviewPage(modelData: model),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                  child: Image.network(
                                    model['image'] ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => 
                                        const Icon(Icons.image, size: 50, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model['title'] ?? 'Untitled',
                                    style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text('Material: ${model['material'] ?? '-'}', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Price ฿${model['price'] ?? 0}',
                                    style: TextStyle(color: Colors.grey.shade800, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Model Preview
class ModelPreviewPage extends StatelessWidget {
  final Map<String, dynamic> modelData;

  const ModelPreviewPage({super.key, required this.modelData});

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
          'Preview Model',
          style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        modelData['image'] ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  Text('Model Order Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDark)),
                  const SizedBox(height: 16),
                  
                  _buildDetailRow('Title:', modelData['title'] ?? '-', primaryDark),
                  _buildDetailRow('Material:', modelData['material'] ?? '-', primaryDark),
                  _buildDetailRow('File Name:', modelData['fileName'] ?? '-', primaryDark),
                  
                  const SizedBox(height: 24),
                  
                  // ราคา
                  Text('Price', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  Text(
                    '฿${modelData['price'] ?? 0}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryDark),
                  ),
                ],
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(color: bgColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: primaryDark, size: 28),
                    const SizedBox(height: 4),
                    Text('Information', style: TextStyle(color: primaryDark, fontSize: 12)),
                  ],
                ),
                SizedBox(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // go to FindStorePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FindStorePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Find Store',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // detail
  Widget _buildDetailRow(String label, String value, Color primaryDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: primaryDark, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}