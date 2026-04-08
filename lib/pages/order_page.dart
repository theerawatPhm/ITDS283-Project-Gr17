import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);
  final Color successGreen = const Color(0xFF4CAF50);

  //function Complete Order
  Future<void> _completeOrder(String docId) async{
    try{
      await FirebaseFirestore.instance.collection('app3dnow_order').doc(docId).update({
        'status' : 'Complete',
      });
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order marked as Complete!')));
      }
    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error $e')));
      }
    }
  }

  //function cancel and delete order
  Future<void> _cancelOrder(String docId) async{
    try{
      await FirebaseFirestore.instance.collection('app3dnow_order').doc(docId).delete();
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order canceled successfully')));
      }
    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error $e')));
      }
    }
  }

  //pop up ก่อนกด Cancel Make sure ก่อน
 void _showCancelDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Order?', style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to cancel this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, keep it', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              _cancelOrder(docId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCompleteDialog(BuildContext context, String docId){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
          title: Text('Complete Order?', style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to mark this order as complete?'),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: ()=> Navigator.pop(context),
              child: const Text('Cancle', style: TextStyle(color: Colors.grey)),
              ),
            ElevatedButton(
              onPressed: (){
                _completeOrder(docId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: successGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Yes, Complete', style: TextStyle(color: Colors.white),))
          ],
      ));
  }

  @override
  Widget build(BuildContext context) {
    // final processingOrders = allOrder.where((order) => order['status'] == 'Processing').toList();
    // final completeOrders = allOrder.where((order) => order['status'] == 'Complete').toList();

    return DefaultTabController(length: 3,
    child: Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(child: Column(
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            children: [
              Center(
                child: Text('Your Orders', style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: primaryDark,),),
              ),
              const SizedBox(height: 24,),
              const CustomSearchBar(hintText: 'Search order...'),
              const SizedBox(height: 20,),

              // ProcessingBanner(orderCount: processingOrders.length, progressPercent: 40
              // ),
              StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
              .collection('app3dnow_order')
              .where('status', isEqualTo: 'Processing')
              .snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator(),),
                  );
                }

                int count = snapshot.hasData ? snapshot.data!.docs.length : 0;

                if(count == 0){
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryOrange,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryOrange.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Text(
                        'No Active Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  );
                }

                return ProcessingBanner(
                  orderCount: count,);
              },
            ),
            ],
            ),
          ),
          TabBar(
            labelColor: primaryOrange,
            unselectedLabelColor: primaryDark,
            indicatorColor: primaryOrange,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'In Process',),
              Tab(text: 'Complete',)
            ]
          ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('app3dnow_order').orderBy('createdAt', descending: true)
            .snapshots(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: primaryOrange,));
              }

              if(snapshot.hasError){
                return Center(child: Text('Error', style: const TextStyle(color: Colors.red)));
              }

              if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                return const Center(child: Text('No orders found', style: TextStyle(color: Colors.grey, fontSize: 16),));
              }

              final allOrders = snapshot.data!.docs.map((doc){
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                return data;
              }).toList();

              final processingOrders = allOrders.where((order) => order['status'] == 'Processing').toList();
              final completeOrders = allOrders.where((order) => order['status'] == 'Complete').toList();
              
              return TabBarView(
                children: [
                  _buildOrderList(allOrders),
                  _buildOrderList(processingOrders),
                  _buildOrderList(completeOrders),
                ]);
            },
            
          ),
          ),
        ],
      )),
    ));
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders){

    if(orders.isEmpty){
      return const Center(child: Text('No orders', style:  TextStyle(color: Colors.grey),));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: orders.length,
      itemBuilder: (context, index){
        return _buildOrderCard(orders[index]);
      }
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order){
    final bool isComplete = order['status'] == 'Complete';
    final Color statusColor = isComplete ? successGreen : primaryOrange;

    IconData displayIcon = Icons.print;
    if(order['iconPath'] == 'designer_icon'){
      displayIcon = Icons.design_services;
    }

    String rawFileName = order['fileName'] ?? '';
    String displayTitle = rawFileName;

    if(displayTitle.contains('.')){
      displayTitle = displayTitle.substring(0, displayTitle.lastIndexOf('.'));
    }
    //emergency case naka
    if(displayTitle.isEmpty) displayTitle = 'Model Order';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(displayIcon, size: 40, color: Colors.blueGrey),
              ),
              const SizedBox(width: 16),

              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark, fontSize: 14),),
                  const SizedBox(height: 8),
                  _buildDetailText('Material:', order['material'] ?? '-'),
                  _buildDetailText('Quality:', order['quality'] ?? '-'),
                  _buildDetailText('Scrub:', order['scrub'] ?? '-'),
                  _buildDetailText('Color:', order['color'] ?? '-'),
                  _buildDetailText('File:', (rawFileName.isNotEmpty && rawFileName !=  'Designer Request') ? rawFileName : '-'),
                  _buildDetailText('Other:', order['otherText'] ?? order['other'] ?? '-'),
                ],
              ),
              ),
            ],
          ),
          const SizedBox(height: 16,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order['status'] ?? 'Unknown',
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              if(!isComplete)...[
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: ()=> _showCancelDialog(context, order['id']),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.zero
                      ),
                child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
                  ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: ()=> _showCompleteDialog(context, order['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: successGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20)
                ),
                 child: const Text('Complete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                  ],
                )
              ]else ...[
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _showCancelDialog(context, order['id']),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
                        minimumSize: Size(80, 39),
                        padding: EdgeInsets.zero
                      ), child: const Text('Remove', style: TextStyle(color: Colors.black54),),
                    ),
                    const SizedBox(width: 10,),
                    OutlinedButton(onPressed: (){},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryOrange,
                      side: BorderSide(color: primaryOrange),
                      backgroundColor: primaryOrange
                    ), child: const Text('Review', style: TextStyle(color: Colors.white),))
                  ],
                )
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText (String label, String value){
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label,
            style: const TextStyle(fontSize: 10, color: Colors.grey))),
            Expanded(child: Text(value, style: TextStyle(fontSize: 10, color: primaryDark),
            maxLines: 1, overflow: TextOverflow.ellipsis,),)
        ],
      ),
      );
  }
}