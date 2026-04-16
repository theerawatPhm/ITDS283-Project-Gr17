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
    return const Placeholder();
  }
}