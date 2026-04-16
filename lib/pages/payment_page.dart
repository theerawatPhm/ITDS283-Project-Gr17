import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class PaymentPage extends StatefulWidget {

  final double totalAmount;
  final Map<String, dynamic> orderDetails;
  const PaymentPage({super.key, required this.totalAmount, required this.orderDetails});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  String _selectedPaymentMethod = 'Wallet';
  bool _isLoading = false;

  //primary Color
  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);

  Future <void> _submitOrderToFireBase() async{
    setState(() => _isLoading = true);

    try{
      bool hasDesigner = widget.orderDetails['designerDescription'] != null && 
                         widget.orderDetails['designerDescription'].toString().isNotEmpty;

      Map<String, dynamic> finalOrderData = {
        ...widget.orderDetails,
        'totalAmount' : widget.totalAmount,
        'paymentMethod' : _selectedPaymentMethod,
        'status' : 'Processing',
        'createdAt' : FieldValue.serverTimestamp(),
        'iconPath' : hasDesigner ? 'designer_icon' : 'printer_icon',
        'userId' : FirebaseAuth.instance.currentUser?.uid,
      };

      await FirebaseFirestore.instance.collection('app3dnow_order').add(finalOrderData);

      // globalActiveOrders.value += 1;
      
      if (!mounted) return; 
      setState(() => _isLoading = false);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SuccessPage()));
      
    }catch (e){
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
        duration: const Duration(seconds: 5), 
      ));
    }
  }

@override
  Widget build(BuildContext context) {
    
    bool hasDesigner = widget.orderDetails['designerDescription'] != null && widget.orderDetails['designerDescription'].toString().isNotEmpty;
    
    
    String designerName = '-';
    if (hasDesigner) {
       
       String desc = widget.orderDetails['designerDescription'];
       if (desc.startsWith('Hire: ')) {
         designerName = desc.substring(6);
       } else {
         designerName = 'Custom Request';
       }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark)),
                    ),
                    const SizedBox(height: 40),

                    Text('Choose Payment\nOption', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryDark, height: 1.2)),
                    const SizedBox(height: 40),

                    _buildCustomRadio('Wallet', 'Wallet'),
                    _buildCustomRadio('Debit/Credit Card', 'Card'),
                    _buildCustomRadio('QR Prompt Pay', 'PromptPay'),
                    const SizedBox(height: 32),

                    _buildSummaryRow('Total', '฿${widget.totalAmount.toStringAsFixed(1)}\n(vat include)', isTotal: true),
                    const SizedBox(height: 16),
                    
                    _buildSummaryRow('Designer', designerName),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Store', '-'),
                    const SizedBox(height: 32),

                    Text(
                      'Note: Please check all details before confirming your order. If any changes are needed, additional charges may apply.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: primaryOrange),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text('Request Tax Invoice', style: TextStyle(fontSize: 16, color: primaryOrange)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitOrderToFireBase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: _isLoading 
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text('Pay Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomRadio(String title, String value){
    bool isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedPaymentMethod = value;
      }),
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: primaryDark)),
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? primaryOrange : Colors.grey.shade400, width: 2),
            ),
            child: isSelected ? Center(child: Container(width: 12, height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: primaryOrange
            ))) : null
          )
        ],
      ),),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: primaryDark)),
        Text(value, textAlign: TextAlign.right, style: TextStyle(fontSize: 16, color: primaryDark)),
      ],
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = const Color(0xFF4A3B52);
    final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade100, 
                ),
                child: const Icon(Icons.person, size: 100, color: Colors.white), 
              ),
              
              const SizedBox(height: 40),
              Text(
                "We're processing\nyour order",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryDark, height: 1.2),
              ),
              const SizedBox(height: 16),
              Text(
                "You will receive a notification\nonce your order has been completed.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
              ),
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Done', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}