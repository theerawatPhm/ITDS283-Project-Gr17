import 'package:flutter/material.dart';

import 'order_page.dart';
import 'new_order_page.dart';
import 'shared_widgets.dart';
import 'find_store_page.dart';
import 'find_designer_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// final ValueNotifier<int> globalActiveOrders = ValueNotifier<int>(0);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  //PrimaryColor
  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      NewDesign(onBackToHome: (){
        setState(() {
          _selectedIndex = 0;
        });
      }),
      const OrderPage(),
    ];
    return Scaffold(
      backgroundColor: bgColor,
      body: pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Welcome User',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomSearchBar(hintText: 'hintText'),
            // _buildSearchbar(),
            const SizedBox(height: 20),
            // ProcessingBanner(orderCount: 1, progressPercent: 50),
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
                  orderCount: count);
              },
            ),
            const SizedBox(height: 30),
            Text(
              'Our Service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: primaryDark,
              ),
            ),
            const SizedBox(height: 15),
            _buildServicesList(),
            const SizedBox(height: 20),
            Text(
              'What\'s New',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: primaryDark,
              ),
            ),
            const SizedBox(height: 20,),
            _buildWhatsNewList()
          ],
        ),
      ),
    );
  }

  // Widget _buildSearchbar() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(30),
  //       border: Border.all(color: primaryDark, width: 1.5),
  //     ),
  //     child: Row(
  //       children: [
  //         const Padding(
  //           padding: EdgeInsets.only(left: 10, right: 8, top: 5, bottom: 5),
  //           child: Icon(Icons.search, color: Color(0xFF4A3B52), size: 45),
  //           ),
  //         Expanded(
  //           child: TextField(
  //             decoration: InputDecoration(
  //             hintText: 'Search...',
  //             border: InputBorder.none,
  //             hintStyle: const TextStyle(color: Color(0xFF4A3B52), fontSize: 20),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(4.0),
  //           child: ElevatedButton(onPressed: (){},
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: primaryDark,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(24),
  //             ),
  //             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //             elevation: 0,
  //           ),
  //           child: const Text('Enter', style: TextStyle(color: Colors.white),),),),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildProcessingBanner(){
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(30),
  //     decoration: BoxDecoration(
  //       color: primaryOrange,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 2,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text('X order is processing', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
  //               const SizedBox(height: 65,),
  //               Stack(
  //                 clipBehavior: Clip.none,
  //                 alignment: Alignment.centerLeft,
  //                 children: [
  //                   Container(
  //                     height: 8,
  //                     width: double.infinity,
  //                     decoration: BoxDecoration(
  //                       color: Colors.black.withOpacity(0.2),
  //                       borderRadius: BorderRadius.circular(4)
  //                     ),
  //                   ),
  //                   Container(
  //                     height: 8,
  //                     width: 150,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(4),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     top: -35,
  //                     //have to make it movable
  //                     left: 125,
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: Text('%X', style: TextStyle(color: primaryOrange, fontWeight: FontWeight.bold, fontSize: 15),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: Center(
  //             child: SvgPicture.asset('assets/icons/constructionTwo.svg',
  //             colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn,),
  //             width: 80,
  //             height: 80,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  //WIDGET HERE
Widget _buildServicesList() {
    final services = ['Print Stores', 'Find Designer', 'Marketplace',];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: services.map((services) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {

                print('On tap test ${services}');
                if (services == 'Find Designer'){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FindDesignerPage()));
                }else if(services == 'Print Stores'){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FindStorePage()));}
                  },
              child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: primaryDark, width: 1),
              ),
              child: Text(
                services,
                style: TextStyle(
                  color: primaryDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWhatsNewList(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildNewCard(
            title: 'New arrival, Medical model',
            tag: 'NEW',
            date: '2 days ago',
            imagePath: 'assets/img/forceps7.jpg'
          ),
          const SizedBox(width: 16,),
          _buildNewCard(title: 'Orange model has release', tag: '', date: '2 days ago', imagePath: 'assets/img/forceps7.jpg'),
        ],
      ),
    );
  }

  Widget _buildNewCard({
    required String title,
    required String tag,
    required String date,
    required String imagePath,
  }){
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
              ),
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(imagePath, fit: BoxFit.cover,),
              ),
              if(tag.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4
                    ),
                    decoration: BoxDecoration(
                      color: primaryOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(height: 12,),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: primaryDark
            ),
          ),
          const SizedBox(height: 8,),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              date,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  //navigation bar bottom
  Widget _buildBottomNavigationBar(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(icon: Icons.home_outlined, label: 'Home', index: 0),
            _buildNavItem(icon: Icons.add_circle_outline, label: 'New', index: 1),
            _buildNavItem(icon: Icons.check_box_outlined, label: 'Order', index: 2)
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}){
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? primaryOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.white : primaryOrange, size: 28,),
          const SizedBox(height: 4,),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : primaryOrange, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
            ),
          ),
        ],
      ),
        )
    );
  }
}