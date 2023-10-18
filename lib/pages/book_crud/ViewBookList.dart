import 'package:book_exchange/pages/book_crud/bookRequestSend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookListView extends StatefulWidget {
  const BookListView({Key? key});

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Book").snapshots(),
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
              child: Text("No data!"),
            );
          }

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('users').get(),
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

              if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("No user data!"),
                );
              }

              // Create a map of user data for quick lookups
              final Map<String, Map<String, dynamic>> userDataMap = {};
              for (final userDoc in userSnapshot.data!.docs) {
                final userData = userDoc.data() as Map<String, dynamic>;
                userDataMap[userDoc.id] = userData;
              }

              // Build the book list with user data
              final bookList = bookSnapshot.data!.docs.map((bookDoc) {
                final bookData = bookDoc.data() as Map<String, dynamic>;
                final bookId = bookDoc.id;
                final userId = bookData["uid"];
                final userData = userDataMap[userId];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Container(
                      height: 80,
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          bookData["Photo"] ?? "${bookData["Photo"]}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      bookData["title"] ?? "${bookData["Title"]}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookData["author"] ?? "${bookData["Author"]}",
                        ),
                        Text(
                          bookData["status"] ?? "${bookData["Status"]}",
                        ),
                        Text(
                          "Added by: ${userData?["name"] ?? "Unknown User"}",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookRequestScreen(
                                          bookTitle:
                                               "${bookData["Title"]}",
                                          ownerId:
                                          "${bookData["uid"]}",
                                      SerialNo:
                                      "${bookData["SerialNo"]}",
                                      bookId: bookId,
                                        )));
                          },
                          icon: Icon(Icons.view_array_sharp),
                        ),
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
