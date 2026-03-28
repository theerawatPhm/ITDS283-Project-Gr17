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
        {
          'name' : 'Amika 3D Print',
          'service' : 'Resin print',
          'distance' : '0.5 km',
          'location' : 'Pinklao',
          'color' : Colors.blue.shade400,
        },
        {
          'name': 'Boom Bim Print',
          'service': 'General and Resin Print',
          'distance': '0.5 km',
          'location': 'Arun Amarin',
          'color': Colors.teal.shade300,
        },
        {
          'name': 'Sophi Kae',
          'service': 'General Print',
          'distance': '0.9 km',
          'location': 'Bangkok Noi',
          'color': Colors.orange.shade300,
        },
      ];
      isLoading = false;
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
              
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text('Find Stores', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryDark),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: primaryDark, size: 28), onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 4, top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: primaryOrange, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isLoading ? 'Locating' : currentLocation, style: TextStyle(color: primaryOrange, fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                  onPressed: (){
                    // TODO: let user press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 0,
                  ), child: const Text('Enter', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Near you', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
                ),
                OutlinedButton.icon(
                  onPressed: (){},
                  icon: Icon(Icons.filter_alt_outlined, size: 16, color: primaryDark),
                  label: Text('Filter', style: TextStyle(color: primaryDark, fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: BorderSide(color: primaryDark),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ],
            ),
          ),
          //store lists
          Expanded(
            child: isLoading 
            ? Center(child: CircularProgressIndicator(color: primaryOrange,)) : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: stores.length,
              itemBuilder: (context, index){
                return _buildStoreCard(stores[index]);
              },
            ))
          ],
        )),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store){
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoreDetailPage(StoreData: store)),
        );
      },
      child: Container(
        child: Text(store['name']),
      ),
    );
  }
}

class StoreDetailPage extends StatelessWidget {

  final Map<String, dynamic> StoreData;
  const StoreDetailPage({super.key, required this.StoreData});

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = const Color(0xFF4A3B52);
    final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
    final Color bgColor = const Color(0xFFF8F8F8);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text('Find Stores', style: TextStyle(fontSize: 28, color: primaryDark, fontWeight: FontWeight.bold)),
                  Positioned(
                    left: 0,
                    child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back, color: primaryDark, size: 28)
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Text('Detail come soon'),
            ))
          ],
        )),
    );
  }
}