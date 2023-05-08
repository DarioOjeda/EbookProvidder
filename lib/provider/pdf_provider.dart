import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import '../database/db_helper.dart';

class PDF {
  final String id;
  final String path;
  final String title;
  final String author;

  PDF({required this.id, required this.path, required this.title, required this.author});
}

class PDFProvider extends ChangeNotifier {
  List<PDF> _item = [];
  PdfDocument? selectedPDF = null;

  Future insertDatabase(
    String path,
    String title,
    String author
  ) async {
    final newProduct = PDF(
      id: const Uuid().v1(), path: path, title: title, author: author
    );
    _item.add(newProduct);

    await  DBHelper.insert('pdfs', {
      'id': newProduct.id,
      'path': newProduct.path,
      'title': newProduct.title,
      'author': newProduct.author
    });

    notifyListeners();
  }

  Future<List<PDF>> selectPDFs() async {
    final dataList = await DBHelper.selectPDFs();
    _item = dataList
        .map((item) => PDF(
              id: item['id'],
              path: item['path'], 
              title: item['title'],
              author: item['author']
            ))
        .toList();
    return _item;
  }

  Future<void> changeSelectedPDF(uuid) async {
    
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File("${appDocDir.path}/ebooks/$uuid.pdf");
    final bytes = await file.readAsBytes();
    selectedPDF = PdfDocument.fromBase64String(base64.encode(bytes));

  }

  PdfDocument? getSelectedPDF() {
    return selectedPDF;
  }

  Future<void> deleteAll() async{
    await DBHelper.deleteAll();
    notifyListeners();
  }
}


