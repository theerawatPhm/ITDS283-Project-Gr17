import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_model_page.dart';

class MyModelPage extends StatefulWidget {
  const MyModelPage({super.key});

  @override
  State<MyModelPage> createState() => _MyModelPageState();
}

class _MyModelPageState extends State<MyModelPage> {

  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: ()=> Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: primaryDark, size: 28),
        ),
        title: Text('My Models',
        style: TextStyle(
          color: primaryDark, fontWeight: FontWeight.bold, fontSize: 24
        ),
        ),centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection('app3dnow_marketplace')
        .where('designerId', isEqualTo: currentUser?.uid)
        .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: primaryOrange,),);
          }
          if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16,),
                  Text('There is not model yet.', style: TextStyle(color: Colors.grey),)
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(24.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              var model = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String docId = snapshot.data!.docs[index].id;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300)
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(model['image'] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,),
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(model['title'] ?? 'Untitled', style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4,),
                        Text('฿${model['price'] ?? 0}', style: TextStyle(color: primaryDark, fontSize: 14),),
                        const SizedBox(height: 4,),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> EditModelPage(docId: docId, modelData: model)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryDark,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 4)
                          ),
                          child: const Text('Edit', style: TextStyle(color: Colors.white, fontSize: 12),)),
                        )
                      ],
                    ),)
                  ],
                ),
              );
            },
            );
        }
        ),
    );  
  }
}