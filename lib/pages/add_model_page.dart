import 'dart:io';

import 'package:app_3d_now/pages/shared_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddModelPage extends StatefulWidget {
  const AddModelPage({super.key});

  @override
  State<AddModelPage> createState() => _AddModelPageState();
}

class _AddModelPageState extends State<AddModelPage> {
  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);
  final Color fillGrey = const Color(0xFFE0E0E0);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedMaterial = 'PLA';

  //3D file
  File? _selectedFile;
  String? _fileName;

  //Preview Photo
  File? _previewImage;
  String? _imageName;

  bool _isLoading = false;

  Future <void> _pickFile() async{
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['stl', 'obj', 'gcode', 'zip'],
    );
    if(result != null){
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _pickImage() async{
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.image,
    );
    if(result!= null){
      setState(() {
        _previewImage = File(result.files.single.path!);
        _imageName = result.files.single.name;
      });
    }
  }

Future<void> _saveModel() async {
    if (_titleController.text.isEmpty || _priceController.text.isEmpty || _selectedFile == null || _previewImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields, upload 3D file and preview image')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

      try{
        final user = FirebaseAuth.instance.currentUser;
        String filePath = 'marketplace_models/${DateTime.now().millisecondsSinceEpoch}_$_fileName';
        Reference ref = FirebaseStorage.instance.ref().child(filePath);
        await ref.putFile(_selectedFile!);

        String downloadUrl = await ref.getDownloadURL();

        String imagePath = 'marketplace_image/${DateTime.now().microsecondsSinceEpoch}_$_imageName';
        Reference imgRef = FirebaseStorage.instance.ref().child(imagePath);
        await imgRef.putFile(_previewImage!);
        String imageDownloadUrl = await imgRef.getDownloadURL();


        await FirebaseFirestore.instance.collection('app3dnow_marketplace').add({
          'title': _titleController.text.trim(),
          'material': _selectedMaterial,
          'price': double.parse(_priceController.text),
          'designerId' : user?.uid,
          'image': imageDownloadUrl,
          'fileUrl' : downloadUrl,
          'fileName' : _fileName,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if(mounted){
          Navigator.pop(context);
        }
      }catch (e){
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error $e')));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text('Add New Model', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark, fontSize: 28)),
                    Positioned(
                      left: 0,
                      child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back, size: 28, color: primaryDark),
                    ),
                  ),
                  ],
                ),
              ),
            ),
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15,),
                  Text('Upload Model', style: TextStyle(color: primaryDark, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8,),
                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primaryOrange, width: 1.5, style: BorderStyle.solid)
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.cloud_upload_outlined, color: primaryOrange, size: 40,),
                          const SizedBox(height: 10,),
                          Text(_fileName ?? 'Tap to select .stl or .obj file',
                          style: TextStyle(color: _fileName != null ? primaryDark : Colors.grey,
                          fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  if(_fileName != null) _buildClearButton(()=> setState(() {
                    _selectedFile = null; _fileName = null;
                  })),
                  const SizedBox(height: 15,),
                  Text('Model Name', style: TextStyle(color: primaryDark, fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 8,),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      hintText: 'e.g. 3D Car model',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Text('Price (฿)', style: TextStyle(color: primaryDark, fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 8,),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      hintText: '0.00',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)
                    ),
                  ),
                  const SizedBox(height: 15,),

                  Text('Material', style: TextStyle(color: primaryDark, fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 8,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: BoxDecoration(
                      color: fillGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMaterial,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        icon: Icon(Icons.keyboard_arrow_down, color: primaryDark,),
                        items: ['PLA', 'Resin', 'ABS', 'TPU'].map((String val){
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val, style: TextStyle(color: primaryDark)),
                        );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedMaterial = val!)
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Text('Preview Image', style: TextStyle(color: primaryDark, fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 8,),
                  _buildUploadBox(onTap: _pickImage, hint: 'Upload model image for Marketplace', icon: Icons.image_outlined, previewImage: _previewImage),
                  if(_imageName != null) _buildClearButton(() => setState(() {
                    _previewImage = null; _imageName = null;
                  })),
                ],
              ),
            ),
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(color: bgColor),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveModel ,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    elevation: 0,
                  ),
                  child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('List to Marketplace', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox({required VoidCallback onTap, String? displayFileName, required hint, required IconData icon, File? previewImage}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryOrange, width: 1.5, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            if(previewImage != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(previewImage, height: 100, fit: BoxFit.cover),
              ),
            )
            else
            Icon(icon, color: primaryOrange, size: 40,),
            const SizedBox(height: 10,),
            Text(displayFileName ?? hint,
            style: TextStyle(color: displayFileName != null ? primaryDark : Colors.grey, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton (VoidCallback onClear){
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(padding: const EdgeInsets.only(top: 8),
      child: OutlinedButton(onPressed: onClear,
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrange,
        side: BorderSide(color: primaryOrange),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
      ),
      child: const Text('Clear')),),
    );
  }
}