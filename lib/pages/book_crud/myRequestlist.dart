import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRequestListView extends StatefulWidget {
  const UserRequestListView({Key? key}) : super(key: key);

  @override
  _UserRequestListViewState createState() => _UserRequestListViewState();
}

class _UserRequestListViewState extends State<UserRequestListView> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> acceptRequest(String requestId) async {
  //   //for delete one table document named requests
  //   // try {
  //   //   await FirebaseFirestore.instance
  //   //       .collection('requests')
  //   //       .doc(requestId) // Use the requestId variable here, not a string
  //   //       .delete();
  //   //   print("Document deleted successfully");
  //   // } catch (e) {
  //   //   print("Error deleting document: $e");
  //   // }
  //
  //   //for update one table status named requests
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('requests')
  //         .doc(requestId)
  //         .update({'status': 'Accepted'}); // Update the status field
  //     print("Request status updated to 'Accepted'");
  //   } catch (e) {
  //     print("Error updating request status: $e");
  //   }
  //
  //   //for update  table status named requests and book
  // }

  Future<void> acceptRequestStatus(String requestId, String bookId) async {
    try {
      // Update the status in the "requests" collection
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({'status': 'Accepted'});

      await FirebaseFirestore.instance
          .collection('Book')
          .doc(bookId)
          .update({'Status': 'Unavailable'});

      print("Request status updated to 'Accepted'");


      // Query the "Books" collection for a document where SerialNo matches serialNo
    //   QuerySnapshot bookQuery = await FirebaseFirestore.instance
    //       .collection('Books')
    //       .where('SerialNo', isEqualTo: serialNo)
    //       .get();
    //
    //   if (bookQuery.docs.isNotEmpty) {
    //     // If a matching book document is found, update its status to 'Unavailable'
    //     final bookDocId = bookQuery.docs.first.id;
    //     await FirebaseFirestore.instance
    //         .collection('Books')
    //         .doc(bookDocId)
    //         .update({'status': 'Unavailable'});
    //     print("Book status updated to 'Unavailable'");
    //   } else {
    //     print("No book found with SerialNo: $serialNo");
    //   }
    } catch (e) {
      print("Error updating request status: $e");
    }
  }

  Future<void> cancelRequest(String requestId) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Requests"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("requests")
            .where("receiverUid", isEqualTo: _auth.currentUser?.uid)
            .where("status", isEqualTo: "pending")
            .snapshots(),
        // stream: FirebaseFirestore.instance
        //     .collection("requests")
        //     .where("senderUid", isEqualTo: _auth.currentUser?.uid)
        //     .where("status", isEqualTo: "Accepted")
        //     .snapshots(),
        builder: (context, requestSnapshot) {
          if (requestSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (requestSnapshot.hasError) {
            return Center(
              child: Text("Error: ${requestSnapshot.error}"),
            );
          }

          if (!requestSnapshot.hasData || requestSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No requests found for the current user."),
            );
          }

          return ListView(
            children: requestSnapshot.data!.docs.map((requestDoc) {
              final requestData = requestDoc.data() as Map<String, dynamic>;
              final requestId = requestDoc.id;

              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    requestData["bookTitle"] ?? "${requestData["bookTitle"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    requestData["message"] ?? "${requestData["message"]}",
                  ),
                  // Add Accept and Cancel buttons
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          acceptRequestStatus(requestId, requestData["bookId"]);
                          // You can add logic for what happens after accepting the request
                        },
                        child: Text("Accept"),
                      ),
                      SizedBox(width: 10), // Add spacing between buttons
                      ElevatedButton(
                        onPressed: () {
                          cancelRequest(requestId);
                          // You can add logic for what happens after canceling the request
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: UserRequestListView(),
    ),
  ));
}
