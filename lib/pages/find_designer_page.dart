import 'package:flutter/material.dart';

class FindDesignerPage extends StatelessWidget {
  const FindDesignerPage({super.key});

  @override
  Widget build(BuildContext context) {

    //PrimaryColor
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Find Designer',
          style: TextStyle(
            color: primaryDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // 1. รูปภาพ 3D Illustration
              Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/img/designer_img.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      Icon(Icons.image, size: 100, color: Colors.grey[300]),
                ),
              ),
              
              const SizedBox(height: 30),

              
              Text(
                "We'll find designers near you",
                style: TextStyle(
                  color: primaryDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 20),

              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: primaryDark, width: 1),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Location...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 20, top: 14, bottom: 14),
                    
                    // ปุ่ม Enter
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // คำสั่งเมื่อกดปุ่ม Enter
                          print("กดปุ่ม Enter ค้นหาโลเคชั่น");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDark,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Enter',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}