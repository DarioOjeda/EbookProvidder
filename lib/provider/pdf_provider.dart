import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import '../database/db_helper.dart';

class PDF {
  final String id;
  final String path;
  final String title;

  PDF({required this.id, required this.path, required this.title});
}

class PDFProvider extends ChangeNotifier {
  List<PDF> _item = [];
  PDF? selectedPDF = null;

  Future insertDatabase(
    String path,
    String title
  ) async {
    final newProduct = PDF(
      id: const Uuid().v1(), path: path, title: title,
    );
    _item.add(newProduct);

    await  DBHelper.insert('pdfs', {
      'id': newProduct.id,
      'path': newProduct.path,
      'title': newProduct.title
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
            ))
        .toList();
    return _item;
  }

  void changeSelectedPDF(uuid) {
    selectedPDF = _item.firstWhere( (el) => el.path == uuid );
  }
  PDF? getSelectedPDF() {
    return selectedPDF;
  }
}


