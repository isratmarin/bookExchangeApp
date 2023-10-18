// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class AddBook extends StatefulWidget {
//   const AddBook({super.key});
//
//   @override
//   State<AddBook> createState() => _AddBookState();
// }
//
// class _AddBookState extends State<AddBook> {
//   final _addingFormKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _authorController = TextEditingController();
//   final _genreController = TextEditingController();
//   final _yearController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   String _status = 'To Be Read'; // Default status
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Form(
//           key: _addingFormKey,
//           child: ListView(
//             padding: EdgeInsets.all(16.0),
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _authorController,
//                 decoration: InputDecoration(labelText: 'Author'),
//                 // Add validation if needed
//               ),
//               TextFormField(
//                 controller: _genreController,
//                 decoration: InputDecoration(labelText: 'Genre'),
//                 // Add validation if needed
//               ),
//               TextFormField(
//                 controller: _yearController,
//                 decoration: InputDecoration(labelText: 'Publication Year'),
//                 keyboardType: TextInputType.number,
//                 // Add validation if needed
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 // Add validation if needed
//               ),
//               DropdownButtonFormField<String>(
//                 value: _status,
//                 onChanged: (newValue) {
//                   setState(() {
//                     _status = newValue!;
//                   });
//                 },
//                 items: <String>['To Be Read', 'Currently Reading', 'Read']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_addingFormKey.currentState!.validate()) {
//                     // Form is valid, handle submission here
//                     // You can access the form values via _titleController.text, _authorController.text, etc.
//                     // Add your logic to save the book to your list or database here
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         )
//
//     );
//     @override
//     void dispose() {
//       _titleController.dispose();
//       _authorController.dispose();
//       _genreController.dispose();
//       _yearController.dispose();
//       _descriptionController.dispose();
//       super.dispose();
//     }
//   }
// }

//
// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:book_exchange/pages/logform/user_login.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   TextEditingController _username = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController _dob = TextEditingController();
//
//   File? profilepic;
//
//   void logOut() async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.popUntil(context, (route) => route.isFirst);
//     Navigator.pushReplacement(
//         context, CupertinoPageRoute(builder: (context) => UserLogin()));
//   }
//
//   void saveUser() async {
//     String name = nameController.text.trim();
//     String username = _username.text.trim();
//     String email = emailController.text.trim();
//     String ageString = ageController.text.trim();
//     String dobString = _dob.text.trim();
//
//     int age = int.parse(ageString);
//     //int dob = int.parse(dobString);
//
//     nameController.clear();
//     _username.clear();
//     emailController.clear();
//     ageController.clear();
//     _dob.clear();
//     _username.clear();
//
//     //if (name != "" && email != "" && profilepic!=null)
//     if (name != "" && email != "") {
//       UploadTask uploadTask = FirebaseStorage.instance.ref().child("profilepictures").child(Uuid().v1()).putFile(profilepic!);
//
//       StreamSubscription taskSubscription = uploadTask.snapshotEvents.listen((snapshot) {
//         double percentage = snapshot.bytesTransferred/snapshot.totalBytes * 100;
//         log(percentage.toString());
//       });
//
//       TaskSnapshot taskSnapshot = await uploadTask;
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//
//       taskSubscription.cancel();
//       // UploadTask uploadTask =  FirebaseStorage.instance.ref().child("profilepictures").child(Uuid().v1()).putFile(profilepic!);
//       //         TaskSnapshot taskSnapshot = await uploadTask;
//       //         String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//       Map<String, dynamic> userData = {
//         "name": name,
//         "username": username,
//         "email": email,
//         "age": age,
//         "dob": dobString,
//         "profilepic": downloadUrl,
//         "sampleArray": [name, username, email, age, dobString]
//       };
//       FirebaseFirestore.instance.collection("users").add(userData);
//       log("User created!");
//     } else {
//       log("Please fill all the fields!");
//     }
//
//     setState(() {
//       profilepic = null;
//     });
//   }
//
//   //update Data
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   void updateUser() async {
//     await _firestore.collection("users").doc("0lZksxcdouOlAZaKoYXX").update({
//       "name": "Hasan Mahmud",
//       "email": "hasanlaks@gmail.com",
//       "age" : 25,
//     });
//     log("User Updated");
//   }
//
//   void deleteUser() async {
//     await _firestore.collection("users").doc("eZJ1G5KWx2GiWf2r9Y1g").delete();
//     log("User Deleted");
//   }
//
//   // void getInitialMessage() async {
//   //   RemoteMessage? message =
//   //   await FirebaseMessaging.instance.getInitialMessage();
//   //
//   //   if (message != null) {
//   //     if (message.data["page"] == "email") {
//   //       Navigator.push(
//   //           context, CupertinoPageRoute(builder: (context) => SignUpScreen()));
//   //     } else if (message.data["page"] == "phone") {
//   //       Navigator.push(context,
//   //           CupertinoPageRoute(builder: (context) => SignInWithPhone()));
//   //     } else {
//   //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //         content: Text("Invalid Page!"),
//   //         duration: Duration(seconds: 5),
//   //         backgroundColor: Colors.red,
//   //       ));
//   //     }
//   //   }
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//
//     // getInitialMessage();
//     //
//     // FirebaseMessaging.onMessage.listen((message) {
//     //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     //     content: Text(message.data["myname"].toString()),
//     //     duration: Duration(seconds: 10),
//     //     backgroundColor: Colors.green,
//     //   ));
//     // });
//     //
//     // FirebaseMessaging.onMessageOpenedApp.listen((message) {
//     //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     //     content: Text("App was opened by a notification"),
//     //     duration: Duration(seconds: 10),
//     //     backgroundColor: Colors.green,
//     //   ));
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               logOut();
//             },
//             icon: Icon(Icons.exit_to_app),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             children: [
//
//               //profile Picture
//               CupertinoButton(
//                 onPressed: () async {
//                   XFile? selectedImage = await ImagePicker()
//                       .pickImage(source: ImageSource.gallery);
//
//                   if (selectedImage != null) {
//                     File convertedFile = File(selectedImage.path);
//                     setState(() {
//                       profilepic = convertedFile;
//                     });
//                     log("Image selected!");
//                   } else {
//                     log("No image selected!");
//                   }
//                 },
//                 padding: EdgeInsets.zero,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage:
//                   (profilepic != null) ? FileImage(profilepic!) : null,
//                   backgroundColor: Colors.grey,
//                 ),
//               ),
//
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(hintText: "Name"),
//               ),
//
//               SizedBox(
//                 height: 3,
//               ),
//               TextField(
//                 controller: _username,
//                 decoration: InputDecoration(hintText: "Username"),
//               ),
//
//               SizedBox(
//                 height: 3,
//               ),
//
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(hintText: "Email Address"),
//               ),
//
//               SizedBox(
//                 height: 3,
//               ),
//
//               TextField(
//                 controller: ageController,
//                 decoration: InputDecoration(hintText: "Age"),
//               ),
//
//               SizedBox(
//                 height: 3,
//               ),
//
//               TextField(
//                 controller: _dob,
//                 decoration: InputDecoration(hintText: "DOB"),
//               ),
//
//               SizedBox(
//                 height: 3,
//               ),
//
//               CupertinoButton(
//                 onPressed: () {
//                   saveUser();
//                 },
//                 child: Text("Save"),
//               ),
//
//               SizedBox(
//                 height: 5,
//               ),
//               CupertinoButton(
//                 onPressed: () {
//                   updateUser();
//                 },
//                 child: Text("Update"),
//               ),
//
//               SizedBox(
//                 height: 5,
//               ),
//               // CupertinoButton(
//               //   onPressed: () {
//               //    deleteUser();
//               //   },
//               //   child: Text("Delete"),
//               // ),
//               //
//               // SizedBox(height: 5,),
//
//               StreamBuilder<QuerySnapshot>(
//                 // both
//                 stream:  FirebaseFirestore.instance.collection("users").where("age", isGreaterThanOrEqualTo: 28).orderBy("age").snapshots(),
//                 // Filtering
//                 // given condition to show data
//                 // stream: FirebaseFirestore.instance.collection("users").where("age", isGreaterThanOrEqualTo: 32).snapshots(),
//                 // null
//                 // stream: FirebaseFirestore.instance.collection("users").where("age", isNull: false).snapshots(),
//                 // show Multiple person value using condition
//                 // stream: FirebaseFirestore.instance.collection("users").where("age", whereIn: [32,35]).snapshots(),
//                 //Arrays single condition   * int arrayContains: 35 * String arrayContains: "Tamim"
//                 // stream: FirebaseFirestore.instance.collection("users").where("samplearray", arrayContains: "Tamim").snapshots(),
//                 // Array Multiple Values or Condition
//                 //stream: FirebaseFirestore.instance.collection("users").where("samplearray", arrayContainsAny: ["Tamim", 35]).snapshots(),
//                 // Ordering
//                 // stream: FirebaseFirestore.instance
//                 //     .collection("users")
//                 // // decending Order
//                 //     // .orderBy("age", descending: true)
//                 // // default ascending
//                 // .orderBy("age")
//                 //     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.active) {
//                     if (snapshot.hasData && snapshot.data != null) {
//                       return Expanded(
//                         child: ListView.builder(
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//                             Map<String, dynamic> userMap =
//                             snapshot.data!.docs[index].data()
//                             as Map<String, dynamic>;
//
//                             return ListTile(
//                               leading: CircleAvatar(
//                                 backgroundImage: NetworkImage(userMap["profilepic"]),
//                               ),
//                               title: Text(
//                                   userMap["name"] + " (${userMap["age"]})"),
//                               subtitle: Text(userMap["email"] + "(${userMap["username"]}"),
//                               //                           trailing: Row(
//                               //                             children: [
//                               //                               IconButton(onPressed: (){
//                               //                                 updateUser();
//                               //                               }, icon: Icon(Icons.update),
//                               // ),
//                               //                             IconButton(onPressed: (){
//                               //                                 deleteUser();
//                               //                               }, icon: Icon(Icons.delete),),
//                               //                             ],
//                               //                           ),
//
//                               trailing: IconButton(
//                                 onPressed: () {
//                                   deleteUser();
//                                 },
//                                 icon: Icon(Icons.delete),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     } else {
//                       return Text("No data!");
//                     }
//                   } else {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Exchange',
      home: AddBookScreen(),
    );
  }
}

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController bookTitle = TextEditingController();
  final TextEditingController auther = TextEditingController();
  final TextEditingController ganra = TextEditingController();
  final TextEditingController publisher = TextEditingController();
  final TextEditingController publishYear = TextEditingController();
  final TextEditingController photo = TextEditingController();

  // Reference to the Firestore collection
  CollectionReference books = FirebaseFirestore.instance.collection('Book');

  Future<void> addUser() async {
    try {
      // Add a new document to the "users" collection
      await books.add({
        'Title': bookTitle.text,
        'auther': auther.text,
        'ganra': ganra.text,
        'publisher': publisher.text,
        'publishYear': publishYear.text,
        'photo': photo.text,

      });

      // Clear the input fields
      bookTitle.clear();
      auther.clear();
      ganra.clear();
      publisher.clear();
      publishYear.clear();
      photo.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User added successfully'),
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add user: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: bookTitle,
              decoration: InputDecoration(labelText: 'Book Name'),
            ),
            TextField(
              controller: auther,
              decoration: InputDecoration(labelText: 'Auther Name'),
            ),
            TextField(
              controller: ganra,
              decoration: InputDecoration(labelText: 'Ganra'),
            ), TextField(
              controller: publisher,
              decoration: InputDecoration(labelText: 'Publisher Name'),
            ),
            TextField(
              controller: publishYear,
              decoration: InputDecoration(labelText: 'Publish year'),
            ),

            TextField(
              controller:photo ,
              decoration: InputDecoration(labelText: 'photo '),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addUser,
              child: Text('Add Book'),
            ),
          ],
        ),
      ),
    );
  }
}
