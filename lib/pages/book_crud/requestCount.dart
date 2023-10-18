import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestCountButton extends StatefulWidget {
  @override
  _RequestCountButtonState createState() => _RequestCountButtonState();
}

class _RequestCountButtonState extends State<RequestCountButton> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference requests =
  FirebaseFirestore.instance.collection('requests');

  int requestCount = 0;

  @override
  void initState() {
    super.initState();
    countPendingRequests();
  }

  void countPendingRequests() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        QuerySnapshot requestSnapshot = await requests
            .where('receiverUid', isEqualTo: currentUser.uid)
            .where('status', isEqualTo: 'Pending') // Filter by status
            .get();

        setState(() {
          requestCount = requestSnapshot.docs.length;
        });
      } catch (e) {
        print('Error counting pending requests: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications,
                color: Colors.blue,
                size: 50,
              ),
              if (requestCount > 0)
                Container(
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$requestCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
