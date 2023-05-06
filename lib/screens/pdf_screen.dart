import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/pdf_provider.dart';


class PDFReaderScreen extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {

    PDF? pdf = Provider.of<PDFProvider>(context, listen: false).getSelectedPDF();

    return Scaffold(
      body: Center(
        child: Center(
          child: Container(
            color: Colors.red,
            child: Text(
              pdf != null ?
                pdf.title
                : ''
            ),
          ),
        ),
     ),
   );
  }
}