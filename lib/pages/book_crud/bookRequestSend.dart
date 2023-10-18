import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookRequestScreen extends StatefulWidget {
  final String bookTitle;
  final String ownerId;
  final String SerialNo;
  final String bookId;

  const BookRequestScreen({
    Key? key,
    required this.bookTitle,
    required this.ownerId,
    required this.SerialNo,
    required this.bookId,
  }) : super(key: key);

  @override
  _BookRequestScreenState createState() => _BookRequestScreenState();
}

class _BookRequestScreenState extends State<BookRequestScreen> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference requests =
  FirebaseFirestore.instance.collection('requests');

  Future<void> sendRequest() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        await requests.add({
          'SerialNo': widget.SerialNo,
          'bookId': widget.bookId,
          'senderUid': currentUser.uid,
          'receiverUid': widget.ownerId, // Receiver's UID
          'bookTitle': widget.bookTitle, // Book title
          'message': messageController.text,
          'status': 'pending', // Initial status
          'timestamp': FieldValue.serverTimestamp(),
        });
        messageController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request sent successfully'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send request: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
            ElevatedButton(
              onPressed: sendRequest,
              child: Text('Send Request'),
            ),
          ],
        ),
      ),
    );
  }
}
