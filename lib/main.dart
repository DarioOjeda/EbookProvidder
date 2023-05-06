import 'dart:io';
import 'dart:convert' show base64;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sorry_provider/screens/home_screen.dart';
import 'package:sorry_provider/screens/pdf_screen.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';

import 'provider/pdf_provider.dart';
void main() => runApp(
  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PDFProvider()),
      ],
      child: const MyApp(),
  ),
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
   debugShowCheckedModeBanner: false,
   title: 'Ebook App with provider',
   initialRoute: 'home',
   routes: {
     'home': ( _ ) => HomeScreen(),
     'pdf_reader': ( _ ) => PDFReaderScreen()
   },
   home: Scaffold(
       appBar: AppBar(
          title: Text('Ebook')
       ), 
    ),
   );
  }
}

