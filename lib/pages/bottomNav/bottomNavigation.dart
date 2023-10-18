import 'package:book_exchange/pages/book_crud/searchBook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget bottomNav(BuildContext context) {
  return  BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
          label: 'Home',
          icon: IconButton(
            onPressed: (){},
            icon: Icon(Icons.home),
          )
      ),
      BottomNavigationBarItem(
          label: 'search',
          icon: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BookSearchPage()));
            },
            icon: Icon(Icons.search),
          )
      ),
    ],
  );
}
