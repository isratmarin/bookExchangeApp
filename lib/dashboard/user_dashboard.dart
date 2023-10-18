import 'package:book_exchange/api_sevices/apiservices.dart';
import 'package:book_exchange/pages/book_crud/ViewBookList.dart';
import 'package:book_exchange/pages/book_crud/addbook.dart';
import 'package:book_exchange/pages/book_crud/bookListSpecificUser.dart';

import 'package:book_exchange/pages/book_crud/myRequestlist.dart';
import 'package:book_exchange/pages/bottomNav/bottomNavigation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/book_crud/updatebook.dart';
import '../pages/calling.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference requests =
      FirebaseFirestore.instance.collection('requests');
  int requestCount = 0;
  String searchValue = '';
  final List<String> _suggestions = [];
  final ApiService _apiService = ApiService();

  late User? _currentUser;
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    countPendingRequests();
  }

  void _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });

      // Fetch additional user data from Firestore
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        setState(() {
          _userName = userData['name'];
          _userEmail = userData['email'];
        });
      }
    }
  }

  void countPendingRequests() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        QuerySnapshot requestSnapshot = await requests
            .where('receiverUid', isEqualTo: currentUser.uid)
            .where('status', isEqualTo: 'pending') // Filter by status
            .get();

        setState(() {
          requestCount = requestSnapshot.docs.length;
        });
      } catch (e) {
        print('Error counting requests: $e');
      }
    }
  }

  void countActivatedRequests() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        QuerySnapshot requestSnapshot = await requests
            .where('senderUid', isEqualTo: currentUser.uid)
            .where('status', isEqualTo: 'Ac') // Filter by status
            .get();

        setState(() {
          requestCount = requestSnapshot.docs.length;
        });
      } catch (e) {
        print('Error counting requests: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:bottomNav(context),
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Dashboard'),

        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserRequestListView()));
            },
            child: Container(
              margin: EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(Icons.notification_add
                  ,size: 35,),
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
          IconButton(onPressed: (){}, icon: Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("images/drawerheader.jpeg"),
              ),
              accountName: Text(_userName),
              accountEmail: Text(_userEmail),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text("Book List"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookListView()));
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add Book"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddBookScreen()));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.add),
            //   title: Text("Add E Book"),
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => PdfUploadScreen()));
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("My Library"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserBookListView()));
              },
            ),
            // Add other drawer items as needed
          ],
        ),
      ),
      // The rest of your code...
    );
  }
}

/////Old Code.............................................OldCode..........
//
// import 'package:book_exchange/api_sevices/apiservices.dart';
//
// import 'package:book_exchange/pages/book_crud/ViewBookList.dart';
// import 'package:book_exchange/pages/book_crud/addbook.dart';
// import 'package:book_exchange/pages/book_crud/bookListSpecificUser.dart';
// import 'package:book_exchange/pages/book_crud/bookRequestSend.dart';
// import 'package:book_exchange/pages/book_crud/myRequestlist.dart';
// import 'package:book_exchange/pages/location/currentlocation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_search_bar/easy_search_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../pages/book_crud/updatebook.dart';
//
// class UserDashboard extends StatefulWidget {
//   const UserDashboard({super.key});
//
//   @override
//   State<UserDashboard> createState() => _UserDashboardState();
// }
//
// class _UserDashboardState extends State<UserDashboard> {
// //request counting
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final CollectionReference requests =
//   FirebaseFirestore.instance.collection('requests');
//   int requestCount = 0;
//
//   void countRequests() async {
//     final User? currentUser = _auth.currentUser;
//     if (currentUser != null) {
//       try {
//         QuerySnapshot requestSnapshot = await requests
//             .where('receiverUid', isEqualTo: currentUser.uid)
//             .get();
//
//         setState(() {
//           requestCount = requestSnapshot.docs.length;
//         });
//       } catch (e) {
//         print('Error counting requests: $e');
//       }
//     }
//   }
//
//   //search value storing
//   String searchValue = '';
//   final List<String> _suggestions = [];
//
//   final ApiService _apiService = ApiService();
//
// //Method for crud by restapi
//   // List<Customermodel>? lists = [];
//   //
//   // void findCustomer() async {
//   //   lists = await _apiService.fetchCustomer();
//   //   setState(() {});
//   // }
//   //
//   // Future<int> findCustomer2() async {
//   //   lists = await _apiService.fetchCustomer();
//   //   setState(() {});
//   //   return 0;
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     countRequests();
//     // findCustomer();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: EasySearchBar(
//           backgroundColor: Colors.cyan,
//           title: const Text('Dashboard'),
//           onSearch: (value) => setState(() => searchValue = value),
//           actions: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => UserRequestListView()));
//               },
//               child: Container(
//                   child: Row(
//                     children: [
//                       Icon(Icons.notification_add),
//                       if (requestCount > 0)
//                         Container(
//                           padding: EdgeInsets.all(4),
//                           margin: EdgeInsets.only(left: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Text(
//                             '$requestCount',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                     ],
//                   )),
//             ),
//           ],
//           suggestions: _suggestions),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             UserAccountsDrawerHeader(
//                 currentAccountPicture: CircleAvatar(
//                     backgroundImage: AssetImage("images/drawerheader.jpeg")),
//                 accountName: Text("israt"),
//                 accountEmail: Text("israt@gmail.com")),
//             ListTile(
//               leading: Icon(Icons.book),
//               title: Text("Book List"),
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => BookListView()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.add),
//               title: Text("Add Book"),
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => AddBookScreen()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.history),
//               title: Text("History"),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.location_city),
//               title: Text("My Library"),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => UserBookListView()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.location_city),
//               title: Text("My Location"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CurrentLocation()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.location_city),
//               title: Text("Book request"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => BookRequestScreen(
//                         SerialNo: '',
//                         bookTitle: '',
//                         ownerId: '',
//                       )),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.location_city),
//               title: Text("My BookRequest"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => UserRequestListView()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//
//       //CRUD operation by using spring boot
//       // body: Column(children: [
//       //   // Text('Value: $searchValue'),
//       //   ElevatedButton(onPressed: (){
//       //     FirebaseAuth.instance.signOut();
//       //     Navigator.push(context, MaterialPageRoute(builder: (context)=>UserLogin()));
//       //   }, child: Text("signout")),
//       // ]
//       // )
//       //
//       // body: ListView.builder(
//       //   itemCount: lists!.length,
//       //   itemBuilder: (context, index) {
//       //     return Card(
//       //       color: Colors.white70,
//       //       shadowColor: Colors.deepOrange,
//       //       surfaceTintColor: Colors.white70,
//       //       child: ListTile(
//       //         leading: CircleAvatar(
//       //           backgroundColor: Colors.white,
//       //           child: Text(lists![index].customer_id.toString()),
//       //         ),
//       //         title: Text(lists![index].name),
//       //         subtitle: Column(
//       //           crossAxisAlignment: CrossAxisAlignment.start,
//       //           children: [
//       //             Padding(
//       //               padding: const EdgeInsets.only(bottom: 8.0),
//       //               child: Text(lists![index].email),
//       //             ),
//       //             Text('Phone: ${lists![index].phone}'),
//       //             Text('Address: ${lists![index].address}'),
//       //           ],
//       //         ),
//       //         contentPadding: const EdgeInsets.all(5),
//       //         trailing: Row(
//       //           mainAxisSize: MainAxisSize.min,
//       //           children: [
//       //             IconButton(
//       //               onPressed: () {
//       //                 final customerToEdit = lists![index];
//       //                 Navigator.push(
//       //                     context,
//       //                     MaterialPageRoute(
//       //                       builder: (context) =>
//       //                           UpdateCustomer(customerToEdit: customerToEdit),
//       //                     ));
//       //               },
//       //               icon: const Icon(Icons.edit, color: Colors.black),
//       //             ),
//       //             IconButton(
//       //                 onPressed: () {
//       //                   showDialog(
//       //                     context: context,
//       //                     builder: (BuildContext context) {
//       //                       return AlertDialog(
//       //                         backgroundColor: Colors.white,
//       //                         title: const Text('Confirm Delete'),
//       //                         content: const Text(
//       //                             'Are you sure you want to delete this customer?'),
//       //                         actions: <Widget>[
//       //                           TextButton(
//       //                               onPressed: () {
//       //                                 Navigator.pop(context);
//       //                               },
//       //                               child: const Text('Cancel')),
//       //                           TextButton(
//       //                               onPressed: () {
//       //                                 _apiService.deleteCustomer(
//       //                                     lists![index].customer_id);
//       //                                 findCustomer2();
//       //                                 Navigator.push(
//       //                                     context,
//       //                                     MaterialPageRoute(
//       //                                         builder: (context) =>
//       //                                             UserDashboard()));
//       //                                 setState(() {});
//       //                               },
//       //                               child: const Text('Delete'))
//       //                         ],
//       //                       );
//       //                     },
//       //                   );
//       //                 },
//       //                 icon: const Icon(Icons.delete, color: Colors.red)),
//       //           ],
//       //         ),
//       //       ),
//       //     );
//       //   },
//       // ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     Navigator.push(
//       //         context, MaterialPageRoute(builder: (context) => AddCustomer()));
//       //   },
//       //   child: Icon(Icons.add),
//       // ),
//     );
//   }
// }
