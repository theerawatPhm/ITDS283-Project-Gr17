import 'package:app_3d_now/pages/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'payment_page.dart';


class ReviewOrderPage extends StatelessWidget {

  final String? fileName;
  final String? fileSize;
  final String? designerDescription;

  final String material;
  final String quality;
  final String scrub;
  final String color;
  final String requestFile;
  final String otherText;

  const ReviewOrderPage({super.key,this.fileName,this.fileSize, this.designerDescription,
  required this.material, required this.quality, required this.scrub, required this.color,
  required this.requestFile, required this.otherText});

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = const Color(0xFF4A3B52);
    final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
    final Color bgColor = const Color(0xFFF8F8F8);

    final bool isDesignerOrder = designerDescription != null && designerDescription!.isNotEmpty;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column( 
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0 ,vertical: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text('Review Order', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryDark)),
                  Positioned(
                    left: 0,
                    child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back, color: primaryDark, size: 28,))),
                ],
              ),
            ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16,),
                    
                    // 🔴 3. เช็คเงื่อนไขเพื่อสลับกล่องด้านบน
                    if (isDesignerOrder) 
                      _buildDescriptionBox(designerDescription!, primaryOrange, primaryDark)
                    else 
                      _buildFileBox(fileName ?? 'Unknown File', fileSize ?? '-', primaryOrange, primaryDark),

                    const SizedBox(height: 32,),
                    Text('Model Order Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDark),),
                    const SizedBox(height: 16),
                    _buildDetailRow('Material:', material, primaryDark),
                    _buildDetailRow('Quality:', quality, primaryDark),
                    _buildDetailRow('Scrub:', scrub, primaryDark),
                    _buildDetailRow('Color:', color, primaryDark),
                    _buildDetailRow('File:', requestFile, primaryDark),
                    _buildDetailRow('Other:', otherText, primaryDark),

                    const SizedBox(height: 32,),
                    Text('Purchase', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDark),),
                    const SizedBox(height: 16),
                    _buildDetailRow('Printing fee', '฿600', primaryDark),
                    _buildDetailRow('Designer fee', isDesignerOrder ? '฿900' : '-', primaryDark), // ถ้าไม่ใช่ Designer อาจจะขีดแดชไว้
                    _buildDetailRow('Packaging', '฿70', primaryDark),
                    _buildDetailRow('Delivery', '฿60', primaryDark),
                    _buildDetailRow('Tax (7%)', '฿114.1', primaryDark),
                    const SizedBox(height: 12,),
                    Row(
                      children: [
                        SizedBox(width: 120, child: Text('Total', style: TextStyle(color: primaryDark, fontSize: 16, fontWeight: FontWeight.bold))),
                        Text('฿1744.1', style: TextStyle(color: primaryDark, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 40,),
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
                      Icon(Icons.info_outline, color: primaryDark, size: 28,),
                      const SizedBox(height: 4,),
                      Text('Information', style: TextStyle(color: primaryDark)),
                    ],
                  ),
                  SizedBox(width: 160,height: 50,
                  child: ElevatedButton(onPressed: (){
                    Map<String , dynamic> orderData ={
                        'fileName': fileName ?? 'Designer Request',
                        'designerDescription': designerDescription ?? '',
                        'material': material,
                        'quality': quality,
                        'scrub': scrub,
                        'color': color,
                        'requestFile': requestFile,
                        'otherText': otherText,
                    };
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    PaymentPage(totalAmount: 1777.0, orderDetails: orderData)
                    ));

                  },style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    elevation: 0,
                  ), child: const Text('Next', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)),)
                ],
              ),
        )],
        )),
    );
  }

  Widget _buildFileBox (String name, String size, Color primaryOrange, Color primaryDark){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryOrange, width: 1.2)
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file_outlined, color: primaryOrange, size: 48,),
          const SizedBox(height: 16,),
          Expanded(child: Text(name,
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark, fontSize: 16)),
          ),
          Text(size, style: TextStyle(
            color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 14
          ),)
        ],
      ),
    );
  }

  Widget _buildDescriptionBox(String description, Color primaryOrange, Color primaryDark){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryOrange, width: 1.2),
          ),
          child: Text(description,
          style: TextStyle(color: primaryDark, fontSize: 14, height: 1.5),
          ),
        ),
        const SizedBox(height: 12),
        Text('Note: Please check all description before sent to designer',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        textAlign: TextAlign.center,)
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, Color textColor){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: primaryDark, fontSize: 16)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: textColor, fontSize: 16),))
        ],
      ),
      );
  }
}