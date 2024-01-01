import 'package:barcode_scanner/mainPage.dart';
import 'package:barcode_scanner/product.dart';
import 'package:barcode_scanner/productEditor.dart';
import 'package:barcode_scanner/productViewer.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom()),
        scaffoldBackgroundColor: Colors.grey[800],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 2)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 2)
          ),
          labelStyle: TextStyle(color: Colors.white),
          suffixStyle: TextStyle(color: Colors.white)
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/MainPage' : (context) => MainPage(),
        '/testPage' : (context) => ProductEditor(isEditing: true, isNew: true, product: Product()),
        '/Viewer' : (context) => ProductViewer(),
      },
      initialRoute: '/MainPage',
    );
  }
}
