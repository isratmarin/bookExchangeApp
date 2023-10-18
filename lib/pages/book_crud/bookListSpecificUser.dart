
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserBookListView extends StatefulWidget {
  const UserBookListView({Key? key}) : super(key: key);

  @override
  _UserBookListViewState createState() => _UserBookListViewState();
}

class _UserBookListViewState extends State<UserBookListView> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Book List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Book")
            .where("uid", isEqualTo: _auth.currentUser?.uid)
            .snapshots(),
        builder: (context, bookSnapshot) {
          if (bookSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (bookSnapshot.hasError) {
            return Center(
              child: Text("Error: ${bookSnapshot.error}"),
            );
          }

          if (!bookSnapshot.hasData || bookSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No books found for the current user."),
            );
          }

          // Process and display the user's book list along with user data
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(_auth.currentUser?.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (userSnapshot.hasError) {
                return Center(
                  child: Text("Error: ${userSnapshot.error}"),
                );
              }

              final userData = userSnapshot.data?.data() as Map<String, dynamic>;

              List<Widget> bookList = bookSnapshot.data!.docs.map((bookDoc) {
                final bookData = bookDoc.data() as Map<String, dynamic>;
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      bookData["title"] ?? "${bookData["Title"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      bookData["author"] ?? "${bookData["Author"]}",
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Added by: ${userData?["name"] ?? "Unknown User"}",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        // You can add more details or actions here
                      ],
                    ),
                  ),
                );
              }).toList();

              return ListView(
                children: bookList,
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: UserBookListView(),
    ),
  ));
}

