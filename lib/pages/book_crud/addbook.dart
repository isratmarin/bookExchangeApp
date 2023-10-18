import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late File? _image = null;
  late String? _uploadedFileURL = "";
  final TextEditingController bookTitle = TextEditingController();
  final TextEditingController author = TextEditingController();
  final TextEditingController genre = TextEditingController();
  final TextEditingController publisher = TextEditingController();
  final TextEditingController publishYear = TextEditingController();


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference books = FirebaseFirestore.instance.collection('Book');

  Future<void> addBook() async {
    try {
      if (_uploadedFileURL != null) {
        String serialNumber = DateTime.now().millisecondsSinceEpoch.toString();
        await books.add({
          'SerialNo': serialNumber,
          'Title': bookTitle.text,
          'Author': author.text,
          'Genre': genre.text,
          'Publisher': publisher.text,
          'Publish Year': publishYear.text,
          'Photo': _uploadedFileURL, // Store the image URL
          'Status': "Available",
          'uid': _auth.currentUser!.uid,
        });

        bookTitle.clear();
        author.clear();
        genre.clear();
        publisher.clear();
        publishYear.clear();
        _uploadedFileURL = null; // Reset the uploaded file URL
        _image = null;
        setState(() {});
      } else {
        print('Failed to add book1');
      }
    } catch (e) {
      print('Failed to add book: $e');
    }
  }

  Future chooseFile() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        uploadFile();
      });
    }
  }

  Future uploadFile() async {
    if (_image != null) {
      try {
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('books/${Path.basename(_image!.path)}');

        final UploadTask uploadTask = storageReference.putFile(_image!);
        await uploadTask.whenComplete(() async {
          final url = await storageReference.getDownloadURL();
          setState(() {
            _uploadedFileURL = url;
          });
          print('File Uploaded');
        });
      } catch (e) {
        print('Failed to upload image: $e');
      }
    } else {
      print('Please choose an image first.');
    }
  }

  void clearSelection() {
    setState(() {
      _image = "" as File;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image != null
                      ? Image.file(
                    _image!,
                    height: 150,
                  )
                      : Container(height: 150),
                  _image == null
                      ? ElevatedButton(
                    child: Text('Choose File'),
                    onPressed: chooseFile,
                  )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  _image != null
                      ? ElevatedButton(
                    child: Text('Upload File'),
                    onPressed: uploadFile,
                  )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: bookTitle,
              decoration: InputDecoration(
                labelText: 'Book Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: author,
              decoration: InputDecoration(
                labelText: 'Author',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: genre,
              decoration: InputDecoration(
                labelText: 'Genre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: publisher,
              decoration: InputDecoration(
                labelText: 'Publisher Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: publishYear,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Publish Year',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: addBook,
              child: Text('Add Book'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
