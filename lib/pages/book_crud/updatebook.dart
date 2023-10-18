import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class UpdateBook extends StatefulWidget {
  final DocumentSnapshot docSnapshot;
  const UpdateBook({super.key, required this.docSnapshot});

  @override
  State<UpdateBook> createState() => _UpdateBookState();
}

class _UpdateBookState extends State<UpdateBook> {
  final CollectionReference _books =
      FirebaseFirestore.instance.collection("Book");
  final TextEditingController bookTitle = TextEditingController();
  final TextEditingController author = TextEditingController();
  final TextEditingController genre = TextEditingController();
  final TextEditingController publisher = TextEditingController();
  final TextEditingController publishYear = TextEditingController();
  final TextEditingController photo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bookTitle.text = widget.docSnapshot["name"];
    author.text = widget.docSnapshot["author"];
    genre.text = widget.docSnapshot["genre"];
    publisher.text = widget.docSnapshot["publisher"];
    publishYear.text = widget.docSnapshot["publishYear"];
    author.text = widget.docSnapshot["authde"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Update"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Book Details",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            TextField(
              controller: bookTitle,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            TextField(
              controller: author,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                labelText: "Author",
                labelStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: genre,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                labelText: "Genre",
                labelStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            TextField(
              controller: publisher,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                labelText: "Publisher",
                labelStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            TextField(
              controller: publishYear,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                labelText: "Publish year",
                labelStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String bookname = bookTitle.text;
                String writter = author.text;
                String bookGenre = genre.text;
                String publisherName = publisher.text;
                String year = publishYear.text;

                if (bookname.isNotEmpty &&
                    writter.isNotEmpty &&
                    bookGenre.isNotEmpty &&
                    publisherName.isNotEmpty &&
                    year.isNotEmpty) {
                  _books.doc(widget.docSnapshot.id).update({
                    "bookTitle": bookname,
                    "author": writter,
                    "genre": bookGenre,
                    "publisher": publisherName,
                    "publishYear": year,
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("UPDATE"),
            ),
          ],
        ),
      ),
    );
  }
}
