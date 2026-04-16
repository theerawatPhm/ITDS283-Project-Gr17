import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditModelPage extends StatefulWidget {

  final Map<String, dynamic> modelData;
  final String docId;

  const EditModelPage({super.key, required this.docId, required this.modelData});

  @override
  State<EditModelPage> createState() => _EditModelPageState();
}

class _EditModelPageState extends State<EditModelPage> {

  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);

  late TextEditingController _titleController;
  late TextEditingController _priceController;

  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController(text: widget.modelData['title']);
    _priceController = TextEditingController(text: widget.modelData['price'].toString());
  }

  Future<void> _updateModel()async{
    try{
      await FirebaseFirestore.instance
      .collection('app3dnow_marketplace')
      .doc(widget.docId)
      .update({
        'title' : _titleController.text,
        'price' : double.parse(_priceController.text),
        'updatedAt' : FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated')));
      Navigator.pop(context);
    }catch (e){
      print('Error updating model: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: ()=> Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: primaryDark,size: 28)),
        title: Text('Edit Model',
        style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.modelData['image'] ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 100, color: Colors.grey,),
                ),
              ),
            ),
            const SizedBox(height: 24,),

            Text('Model Name', style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8,),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20), 
                  borderSide: BorderSide.none
                )
              ),
            ),
            const SizedBox(height: 15,),
            Text('Price (฿)', style: TextStyle(color: primaryDark, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20), 
                  borderSide: BorderSide.none
                )
              ),
            ),
            const SizedBox(height: 40,),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _updateModel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                ),
                child: const Text('Save Changes',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)),
            )
          ],
        ),
      ),
    );  
  }
}