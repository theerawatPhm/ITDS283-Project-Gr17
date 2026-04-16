import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _selectedRole = 'customer';

  void _navigateToLogin() {
    Navigator.pop(context);
  }

//register function
  Future<void> _registerUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password do not match')));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // 1. สร้าง account ใน Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // 2. save info ใน collection 'users'
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. if designer
      if (_selectedRole == 'designer') {
        await FirebaseFirestore.instance.collection('designers').doc(uid).set({
          'uid': uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'specialty': 'New Designer', 
          'rating': '0.0 (0 reviews)', 
          'price': 'Starts at ฿0',      
          'image': 'assets/img/designer_1.jpg', //default pic
        });
      }

      if (mounted) Navigator.pop(context); 

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created successfully! Please login')));
        Navigator.pop(context); 
      }

    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Registration failed')));
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryOrange,
                      ),
                    ),
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRoleButton('Customer', 'Buy model', 'customer', Icons.shopping_bag_outlined),
                        const SizedBox(width: 12),
                        _buildRoleButton('Designer', 'Sell model', 'designer', Icons.brush_outlined),
                      ],
                    ),
                    const SizedBox(height: 30),

                    _buildTextField(controller: _nameController, hintText: 'Full Name', icon: Icons.person_outline, obscureText: false),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _emailController, hintText: 'Email', icon: Icons.email_outlined, obscureText: false),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _passwordController, hintText: 'Password', icon: Icons.lock_outline, obscureText: true),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _confirmPasswordController, hintText: 'Confirm Password', icon: Icons.lock_outline, obscureText: true),
                    const SizedBox(height: 30),

                    //Create Account
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _registerUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryOrange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: const Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        GestureDetector(
                          onTap: _navigateToLogin,
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: primaryDark, size: 28),
                onPressed: _navigateToLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(String title, String subtitle, String roleValue, IconData icon){
    bool isSelected = _selectedRole == roleValue;
    return GestureDetector(
      onTap: (){
        setState(() {
          _selectedRole = roleValue;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(microseconds: 200),
        width: 155,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color: isSelected ? primaryOrange : Colors.grey.shade300,
            width: isSelected ? 2 : 1
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : primaryOrange),
              const SizedBox(height: 8,),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : primaryOrange)),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade300),)
            ],
          ),
        ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon, required bool obscureText}){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade400, width: 1)
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade500, fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey.shade600,),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14)
        ),
      ),
    );
  }
}