import 'package:book_exchange/pages/bottomNav/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;

  void _searchBooks(String query) async {
    if (query.isNotEmpty) {
      final snapshot = await _firestore
          .collection('Book')
          .where(Filter.or(Filter('Title', isEqualTo: query),
              Filter('Author', isEqualTo: query)))
          // .where('Title', isLessThan: query + 'z')
          .get();

      setState(() {
        _searchResults = snapshot.docs;
        _isSearching = false;
      });
    } else {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  // void _searchBooks(String query) async {
  //   if (query.isNotEmpty) {
  //     final snapshot = await _firestore
  //         .collection('Book')
  //         .where('Title', isGreaterThanOrEqualTo: query)
  //         .where('Title', isLessThan: query + 'z')
  //         .get();
  //
  //     setState(() {
  //       _searchResults = snapshot.docs;
  //       _isSearching = false;
  //     });
  //   } else {
  //     setState(() {
  //       _searchResults = [];
  //       _isSearching = false;
  //     });
  //   }
  // }

  Future<void> _refreshSearch() async {
    _isSearching = true;
    _searchBooks(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNav(context),
      appBar: AppBar(
        title: Text('Book Search'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _refreshSearch();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                if (!_isSearching) {
                  _searchBooks(query);
                }
              },
              decoration: InputDecoration(
                labelText: 'Search by Title or Author',
                hintText: 'Enter title or author name',
              ),
            ),
          ),
          Expanded(
            child: _isSearching
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final book = _searchResults[index];
                      return ListTile(
                        title: Text(book['Title']),
                        subtitle: Text(book['Author']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
