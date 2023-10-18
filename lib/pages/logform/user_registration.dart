import 'package:book_exchange/dashboard/user_dashboard.dart';
import 'package:book_exchange/firebase_auth_services/firebase_auth_service.dart';
import 'package:book_exchange/pages/logform/user_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Name...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "EMAIL...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: "PHONE...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "PASSWORD...",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width / 3,
                child: ElevatedButton(
                  onPressed: () {
                    final String email = emailController.text.trim();
                    final String password = passwordController.text.trim();
                    final String name = nameController.text.trim();
                    final String phone =phoneController.text.trim();

                    if (email.isEmpty) {
                      print("Email is Empty");
                    } else {
                      if (password.isEmpty) {
                        print("Password is Empty");
                      } else {
                        if(phone.isEmpty){
                          print("phone is empty");
                        }else{
                          context.read<AuthService>().signUp(
                            name,
                            email,
                            password,
                          ).then((value) async {
                            User user = FirebaseAuth.instance.currentUser!;

                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(user.uid)
                                .set({
                              'uid': user.uid,
                              'name': name,
                              'phone': phone,
                              'email': email,
                              'password': password,
                            });
                          });
                        }
                      }
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserLogin()));
                  },
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
