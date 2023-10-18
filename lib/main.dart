import 'package:book_exchange/dashboard/user_dashboard.dart';
import 'package:book_exchange/firebase_auth_services/firebase_auth_service.dart';
import 'package:book_exchange/pages/book_crud/ViewBookList.dart';
import 'package:book_exchange/pages/logform/user_login.dart';
import 'package:book_exchange/pages/logform/user_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges, initialData: null,
        ),
      ],
      child: MaterialApp(
        title: "APP",
        home: UserLogin(),
      ),
    );
  }
}