import 'package:flutter/material.dart';

class FindStorePage extends StatefulWidget {
  const FindStorePage({super.key});

  @override
  State<FindStorePage> createState() => _FindStorePageState();
}

class _FindStorePageState extends State<FindStorePage> {

  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);

  bool isLoading = false;
  String currentLocation = 'Fetching location...';

  List<Map<String , dynamic>> stores = [];

  @override
  void initState(){
    super.initState();
    _fetchRealLocationAndStores();
  }
  
  Future<void> _fetchRealLocationAndStores() async{
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    //mock up store
    setState(() {
      currentLocation = 'Pinklao';

      stores = [
        // {
        //   'name' = 'Amika 3D Print',
        //   'service' = 'Resin print'
        //   'distance' = '0.5 km',
        //   'location' = 'Pinklao',
        //   'color' = Colors.blue.shade400,
        // },
      ];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16/0)),
          ],
        )),
    );
  }
}