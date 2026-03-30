import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'home_page.dart';

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

  final List<Map<String, dynamic>> allOrder =[{

    'status': 'Processing',
    'material' : 'PLA',
    'quality' : 'Mid',
    'scrub' : 'No',
    'color' : 'Filament Color',
    'file' : 'No',
    'other' : 'No',
    'icon' : Icons.local_shipping,
    },

    {
    'status': 'Processing',
    'material' : 'Resin',
    'quality' : 'High',
    'scrub' : 'Yes',
    'color' : 'spray',
    'file' : 'No',
    'other' : 'No',
    'icon' : Icons.medication,
    },

    {
    'status': 'Complete',
    'material' : 'Resin',
    'quality' : 'High',
    'scrub' : 'Yes',
    'color' : 'spray',
    'file' : 'No',
    'other' : 'No',
    'icon' : Icons.medication,
    }
  ];

  @override
  Widget build(BuildContext context) {
    final processingOrders = allOrder.where((order) => order['status'] == 'Processing').toList();
    final completeOrders = allOrder.where((order) => order['status'] == 'Complete').toList();

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
              ValueListenableBuilder<int>(
                valueListenable: globalActiveOrders,
                builder: (context, count, child){
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
                        child: Text('No active orders right now.',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return ProcessingBanner(orderCount: count,
                  progressPercent: 10);
                })
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
          child: TabBarView(
            children: [
              _buildOrderList(allOrder),
              _buildOrderList(processingOrders),
              _buildOrderList(completeOrders)
            ])),
        ],
      )),
    ));
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders){
    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: orders.length,
      itemBuilder: (context, index){
        return _buildOrderCard(orders[index]);
      }
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order){
    final bool isComplete = order['status'] == ['Complete'].toList();
    final Color statusColor = isComplete ? successGreen : primaryOrange;

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
                child: Icon(order['icon'], size: 40, color: Colors.blueGrey),
              ),
              const SizedBox(width: 16),

              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Model order detail', 
                    style: TextStyle(fontWeight: FontWeight.bold,
                        color: primaryDark, fontSize: 14),),
                  const SizedBox(height: 8),
                  _buildDetailText('Material:', order['material']),
                  _buildDetailText('Quality', order['quality']),
                  _buildDetailText('Scrub', order['scrub']),
                  _buildDetailText('Color', order['color']),
                  _buildDetailText('File', order['file']),
                  _buildDetailText('Other', order['other']),
                ],
              ),
              ),
            ],
          ),
          const SizedBox(height: 16,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order['status'],
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              if(!isComplete)...[
                OutlinedButton(
                  onPressed: (){},
                  style: OutlinedButton.styleFrom(foregroundColor: primaryOrange,
                  side: BorderSide(color: primaryOrange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                child: const Text('Contact Us'),
                ),
              ]else ...[
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: (){},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade600,
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ), child: const Text('Hide this order', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8,),
                    OutlinedButton(onPressed: (){},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryOrange,
                      side: BorderSide(color: primaryOrange),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
                    ), child: const Text('Review', style: TextStyle(fontSize: 12),))
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
            Text(value, style: TextStyle(fontSize: 10, color: primaryDark)),
        ],
      ),
      );
  }
}