import 'dart:ffi';

import 'package:flutter/material.dart';

import 'order_page.dart';
import 'new_order_page.dart';
import 'shared_widgets.dart';
import 'find_store_page.dart';
import 'find_designer_page.dart';
import 'marketplace_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

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
 
void _showProfileModal(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, snapshot) {
            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F8F8), 
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40))
                ),
                child: const Center(child: CircularProgressIndicator())
              );
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String name = userData['name'] ?? 'No Name';
            String email = userData['email'] ?? 'No Email';
            String role = userData['role'] ?? 'customer';

            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)), 
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Icon(Icons.account_circle, size: 80, color: primaryDark,),
                  const SizedBox(height: 16,),
                  Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryDark)),
                  Text(email, style: TextStyle(fontSize: 14, color: primaryDark)),
                  const SizedBox(height: 20,),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryOrange, width: 1.5),
                    ),
                    child: Text(role.toUpperCase(), style: TextStyle(color: primaryOrange, fontWeight: FontWeight.bold)
                    ),
                  ),
                  const SizedBox(height: 30,),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const LoginPage()), 
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryOrange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                        ),
                        child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                      ),
                  )
                ],
              ),
            );
          },
        );
      });
  }

Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48,),
                Text('3D NOW', 
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: primaryDark
                ),
                ),
                IconButton(onPressed: ()=> _showProfileModal(context), icon: Icon(Icons.account_circle), iconSize: 35,)
              ],
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


  //WIDGET HERE
Widget _buildServicesList() {
    final services = ['Print Stores', 'Find Designer', 'Marketplace'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: services.map((service) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                //go to each page
                print('On tap test $service');
                
                if (service == 'Find Designer') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FindDesignerPage()));
                } else if (service == 'Print Stores') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FindStorePage()));
                } else if (service == 'Marketplace') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MarketplacePage()));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: primaryDark, width: 1),
                ),
                child: Text(
                  service,
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