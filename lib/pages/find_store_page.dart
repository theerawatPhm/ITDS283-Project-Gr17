import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'new_order_page.dart';
import 'find_designer_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'payment_page.dart';

class FindStorePage extends StatefulWidget {
  final Map<String, dynamic>? modelData;
  const FindStorePage({super.key, this.modelData});

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

    try {
      bool serviceEnable = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnable){
        throw Exception('Location services are disable.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.denied){
          throw Exception('Location permission are denined');
        }
      }

      if(permission == LocationPermission.deniedForever){
        throw Exception('Location permission are permamently denined.');
      }

      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude, position.longitude);

      Placemark place = placemark[0];
      String realLocationName = '${place.subLocality ?? '' } ${place.locality ?? ''}'.trim(); 
      if(realLocationName.isEmpty) realLocationName = 'Unknown Location';

      setState(() {
        currentLocation = realLocationName;
      });

      final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

      final double lat = position.latitude;
      final double lng = position.longitude;
      final int radius = 5000;
      final String keyword = '3d printing';

      final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&keyword=$keyword&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        List<Map<String, dynamic>> realStores = [];

        for (var placeData in results){
          final double storeLat = placeData['geometry']['location']['lat'];
          final double storeLng = placeData['geometry']['location']['lng'];
          final double distanceInMeters = Geolocator.distanceBetween(lat, lng, storeLat, storeLng);
          final String distanceInKm = (distanceInMeters / 1000).toStringAsFixed(1);

          realStores.add({
            'name' : placeData['name'] ?? 'Unknown Store',
            'service' : '3D Print Service',
            'distance' : '$distanceInKm km',
            'location' : placeData['vicinity'] ?? 'Unknown Address',
            'color' : Colors.blue.shade300
          });
        }

        setState(() {
          stores = realStores.isNotEmpty ? realStores : [
            {
              'name': 'No Real Stores Found Nearby',
              'service': 'Try expanding search radius',
              'distance': '- km',
              'location': 'N/A',
              'color': Colors.grey.shade400,
            }
          ];
          isLoading = false;
        });
      }else{
        throw Exception('Failed to load places from Google');
      }
      //   stores = [
      //   {
      //     'name' : 'Amika 3D Print',
      //     'service' : 'Resin print',
      //     'distance' : '0.5 km',
      //     'location' : 'Pinklao',
      //     'color' : Colors.blue.shade400,
      //   },
      //   {
      //     'name': 'Boom Bim Print',
      //     'service': 'General and Resin Print',
      //     'distance': '0.5 km',
      //     'location': 'Arun Amarin',
      //     'color': Colors.teal.shade300,
      //   },
      //   {
      //     'name': 'Sophi Kae',
      //     'service': 'General Print',
      //     'distance': '0.9 km',
      //     'location': 'Bangkok Noi',
      //     'color': Colors.orange.shade300,
      //   },
      //   ];
      //   isLoading = false;
      // });
    }catch (e){
      setState(() {
        currentLocation = 'Location Error';
        isLoading = false;
      });
      print('Error getting location: $e');
    }
    await Future.delayed(const Duration(seconds: 2));
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
              children: [
                Text('Near you', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoreDetailPage(StoreData: store, modelData: widget.modelData)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade400)
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: store['color'],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.storefront, color: Colors.white, size: 40,),
            ),
            const SizedBox(width: 16,),
            Expanded(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store['name'], style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark, fontSize: 16)),
                  const SizedBox(height: 4,),
                  Text(store['service'], style: TextStyle(color: primaryDark, fontSize: 14)),
                  Text(store['distance'], style: TextStyle(color: primaryDark, fontSize: 14)),
                  Text(store['location'],style: TextStyle(color: primaryDark, fontSize: 14)),
                  const SizedBox(height: 8,),
                ],
              ))
          ],
        ),
      ),
    );
  }
}

class StoreDetailPage extends StatelessWidget {

  final Map<String, dynamic> StoreData;
  final Map<String, dynamic>? modelData;
  const StoreDetailPage({super.key, required this.StoreData,this.modelData});

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
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text('Find Stores', style: TextStyle(fontSize: 24, color: primaryDark, fontWeight: FontWeight.bold)),
                    Positioned(
                      left: 0,
                      child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back, color: primaryDark, size: 28)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: StoreData['color'],
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                      ),
                      //mock up store page เดี๋ยวเอามาใส่เพิ่มจ้า
                      child: const Icon(Icons.storefront, size: 80, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StoreData['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryDark)),
                          const Divider(height: 30),

                          _buildInfoSection('Store detail', '${StoreData['service']}\n${StoreData['distance']}', primaryDark),
                          const SizedBox(height: 16,),
                          _buildInfoSection('Price rate', 'At lease 1 piece, small size\nStart at 5.99', primaryDark),
                          SizedBox(height: 16,),
                          _buildInfoSection('Contact', 'Tel: +66 63 343 3456\nEmail: contact@${StoreData['name'].toString().replaceAll(" ", "").toLowerCase()}.com', primaryDark),

                          const SizedBox(height: 32,),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (modelData != null) {
                                  //ถ้ามี Order แล้ววิ่งเข้า Payment เลย
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(
                                    totalAmount: (modelData!['price'] ?? 0).toDouble() + 5.99,
                                    orderDetails: {
                                      'modelId': modelData!['id'] ?? '',
                                      'title': modelData!['title'] ?? '3D Model',
                                      'storeName': StoreData['name'],
                                      'orderType': 'print_at_store',
                                      'designerDescription': '',
                                    }
                                  )));
                                } else {
                                  _showOrderAlert(context, primaryOrange, primaryDark);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryOrange,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Text('Order Now', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ))
          ],
        )),
    );
  }

  Widget _buildInfoSection(String title, String detail, Color textColor){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 14),),
          const SizedBox(height: 4,),
          Text(detail, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.5)),
        ],
      );
    }

    //alert dialog
    void _showOrderAlert(BuildContext context, Color primaryOrange, Color primaryDark){
      showDialog(context: context,
      builder: (BuildContext dialogContext){
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.all(32),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Do you have\nyour model yet?', style: TextStyle(color: primaryOrange, fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 32,),
              //no btn
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FindDesignerPage()));
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryOrange),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('No, Find a Designer', style: TextStyle(color: primaryOrange),)),
              ),
              const SizedBox(height: 12,),

              //yes btn
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pop(dialogContext);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NewDesign()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ), child: Text('Yes, I do have!', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16,),
              GestureDetector(
                onTap: ()=> Navigator.pop(dialogContext),
                child: Text('Back to find store', style: TextStyle(color: Colors.grey.shade400, fontSize: 12),),
              )
            ],
          ),
        );
      });
    }
}