import 'package:app_3d_now/pages/add_model_page.dart';
import 'package:app_3d_now/pages/my_model_page.dart';
import 'package:app_3d_now/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'find_store_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_3d_now/pages/edit_model_page.dart';

class MarketplacePage extends StatefulWidget {
  final String initialQuery;
  const MarketplacePage({super.key, this.initialQuery = ''});

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

    if(widget.initialQuery.isNotEmpty){
      _searchKeyword = widget.initialQuery.toLowerCase();
      _searchController.text = widget.initialQuery;
    }
  }

  Future<void> _checkUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && mounted) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userRole = (data != null && data.containsKey('role')) ? data['role'] : 'customer';
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
          'Marketplace',
          style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      floatingActionButton: _userRole == 'designer'
          ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton.icon(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> MyModelPage()));
              },
              icon: const Icon(Icons.edit_document, color: Colors.white, size: 20,),
              label: const Text('Edit My Model', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDark,
                elevation: 4,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              ),
              const SizedBox(height: 16,),
              FloatingActionButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddModelPage()));
              },
              backgroundColor: primaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.add, color: Colors.white, size: 28,),),
            ],
          )
          :null,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ModelPreviewPage(modelData: model)));
                      },
                      child: Stack(
                        children: [
                          Container(
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
                                      child: (model['image'] != null && model['image'].toString().isNotEmpty)
                                          ? Image.network(
                                              model['image'],
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => 
                                                  const Icon(Icons.image, size: 50, color: Colors.grey),
                                            )
                                          : const Icon(Icons.image, size: 50, color: Colors.grey),
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
                          
                          if (_userRole == 'admin')
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.9),
                                radius: 18,
                                child: IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.orange, size: 20),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditModelPage(docId: model['id'], modelData: model),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
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

  void _ShowOrderOptionsDialog(BuildContext context, Map<String, dynamic> modelData, Color primaryOrange, Color primaryDark){
    showDialog(
      context: context,
      builder: (BuildContext dialogContext){
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              Text('How would you like\nto get this model?', textAlign: TextAlign.center, style: TextStyle(color: primaryOrange,
              fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              
              //Download Model btn
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(totalAmount: (modelData['price'] ?? 0).toDouble(),
                    orderDetails: {
                      'modelId' : modelData['id'] ?? '',
                      'title' : modelData['title'] ?? '3D Model',
                      'orderType' : 'download', 
                      'fileUrl' : modelData['fileUrl'] ?? '',
                      'designerDescription' : '',
                    },
                    )));
                  },
                  icon: Icon(Icons.file_download_outlined, color: primaryOrange,),
                  label: Text('Download Model', style: TextStyle(color: primaryOrange, fontSize: 16),),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryOrange, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (){
                    Navigator.pop(dialogContext);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FindStorePage(modelData: modelData)));
                  },
                  icon: const Icon(Icons.storefront_outlined, color: Colors.white,),
                  label: const Text('Find Store to print', style: TextStyle(color: Colors.white, fontSize: 16),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              
              GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Text('Cancel', style: TextStyle(color: Colors.grey.shade400, fontSize: 14),),
              )
            ],
          ),
        );
      }
    );
  }

    Future<void> _downloadFile(BuildContext context, String? url) async{
    if(url == null || url.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No 3D file available for download')),
      );
      return;
    }
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)){
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }else{
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not start download'))
        );
      }
    }
  }

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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        modelData['image'] ?? '',
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
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: ()=> _ShowOrderOptionsDialog(context, modelData, primaryOrange, primaryDark),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 0
                ),
                child: const Text('Order Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)),
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