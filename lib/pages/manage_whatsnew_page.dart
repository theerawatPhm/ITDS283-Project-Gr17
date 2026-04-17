import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ManageWhatsNewPage extends StatefulWidget {
  const ManageWhatsNewPage({super.key});

  @override
  State<ManageWhatsNewPage> createState() => _ManageWhatsNewPageState();
}

class _ManageWhatsNewPageState extends State<ManageWhatsNewPage> {
  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);

  //deleting Function
  Future<void> _deleteNews(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('app3dnow_whatsnew').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('News deleted')));
    } catch (e) {
      print('Error deleting news: $e');
    }
  }

  void _showAddNewsDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController tagController = TextEditingController();
    File? _selectedImage;
    bool _isUploading = false;

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => StatefulBuilder( 
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Add What\'s New', style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title', labelStyle: TextStyle(color: primaryOrange)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: tagController,
                    decoration: InputDecoration(labelText: 'Tag (e.g. NEW, HOT)', labelStyle: TextStyle(color: primaryOrange)),
                  ),
                  const SizedBox(height: 20),
                  
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      // เปิดแกลเลอรี่ให้เลือกรูป
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _selectedImage = File(image.path);
                        });
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: primaryOrange, width: 1, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(_selectedImage!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined, size: 40, color: primaryOrange),
                                const SizedBox(height: 8),
                                Text('Tap to upload image', style: TextStyle(color: primaryOrange)),
                              ],
                            ),
                    ),
                  ),
                  
                  if (_isUploading) ...[
                    const SizedBox(height: 20),
                    CircularProgressIndicator(color: primaryOrange),
                    const SizedBox(height: 10),
                    const Text('Uploading... Please wait', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ]
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: _isUploading ? null : () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: _isUploading ? null : () async {
                  if (titleController.text.isNotEmpty && _selectedImage != null) {
                    setState(() => _isUploading = true);
                    
                    try {
                      String fileName = 'whatsnew_${DateTime.now().millisecondsSinceEpoch}.jpg';
                      Reference storageRef = FirebaseStorage.instance.ref().child('whatsnew_images/$fileName');
                      UploadTask uploadTask = storageRef.putFile(_selectedImage!);
                      TaskSnapshot taskSnapshot = await uploadTask;
                      
                      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

                      await FirebaseFirestore.instance.collection('app3dnow_whatsnew').add({
                        'title': titleController.text,
                        'tag': tagController.text,
                        'imagePath': downloadUrl,
                        'date': 'Today',
                        'createdAt': FieldValue.serverTimestamp(),
                      });
                      
                      if (context.mounted) Navigator.pop(context); // ปิด Pop-up
                    } catch (e) {
                      print("Error uploading: $e");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload failed!')));
                    } finally {
                      setState(() => _isUploading = false);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter title and select an image')));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryOrange),
                child: const Text('Add News', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        }
      ),
    );
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
        title: Text('Manage What\'s New', style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('app3dnow_whatsnew').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryOrange));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No news yet.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;

              return Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade300)
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.campaign, color: Colors.grey),
                  ),
                  title: Text(data['title'] ?? 'Untitled', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark)),
                  subtitle: Text('Tag: ${data['tag']} | Date: ${data['date']}', style: const TextStyle(fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteNews(doc.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNewsDialog,
        backgroundColor: primaryOrange,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}