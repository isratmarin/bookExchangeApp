import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class PdfUploadScreen extends StatefulWidget {
  @override
  _PdfUploadScreenState createState() => _PdfUploadScreenState();
}

class _PdfUploadScreenState extends State<PdfUploadScreen> {
  File? selectedPdf;
  bool isUploading = false;

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedPdf = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadPDF() async {
    if (selectedPdf == null) {
      // No file selected
      return;
    }

    try {
      setState(() {
        isUploading = true;
      });

      final String foldername = basename(selectedPdf!.path);
      Reference storageReference = FirebaseStorage.instance.ref().child('PdfBook').child(foldername);

      final UploadTask uploadTask = storageReference.putFile(selectedPdf!);

      await uploadTask.whenComplete(() {
        setState(() {
          isUploading = false;
        });
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('PDF uploaded successfully')),
        );
      });

      // Create a Firestore collection
      await createFirestoreCollection();

      // Create a Firebase Storage folder
      await createStorageFolder();
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Error uploading PDF: $e')),
      );
    }
  }

  Future<void> createFirestoreCollection() async {
    try {
      await FirebaseFirestore.instance.collection("your_collection_name").add({
        "field1": "value1",
        "field2": "value2",
      });
      print("Firestore collection created successfully.");
    } catch (e) {
      print("Error creating Firestore collection: $e");
    }
  }

  Future<void> createStorageFolder() async {
    String folderName = "your_folder_name";
    Reference storageReference = FirebaseStorage.instance.ref().child(folderName);

    try {
      await storageReference.putData(Uint8List(0)); // Put empty data to create the folder.
      print("Firebase Storage folder created successfully.");
    } catch (e) {
      print("Error creating Firebase Storage folder: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (selectedPdf != null)
              Text('Selected PDF: ${basename(selectedPdf!.path)}'),
            ElevatedButton(
              onPressed: pickPDF,
              child: Text('Pick a PDF File'),
            ),
            if (selectedPdf != null)
              ElevatedButton(
                onPressed: uploadPDF,
                child: isUploading ? CircularProgressIndicator() : Text('Upload PDF'),
              ),
          ],
        ),
      ),
    );
  }
}
