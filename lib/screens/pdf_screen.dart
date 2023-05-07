import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/pagina.dart';
import '../provider/pdf_provider.dart';


class PDFReaderScreen extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {

    PdfDocument? pdf = Provider.of<PDFProvider>(context, listen: false).getSelectedPDF();
    final _controller = PageController(
      initialPage: 0,
    );

    List<Pagina> paginas = [];
    if(pdf != null) {
      for (var i = 0 ; i < pdf.pages.count - 1; i++ ) {
        String text = PdfTextExtractor(pdf).extractText(startPageIndex: i, endPageIndex: i+1);
        paginas.add(Pagina(text: text, number: i + 1));
      }
    }
    


    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _controller,
          children: <Widget>[
            for (var pagina in paginas) 
              Stack(
                children: [
                   Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Text("Página ${pagina.number + 1}", style: Theme.of(context).textTheme.headlineMedium,)
                  ),
                  SingleChildScrollView(
                     child: Center(child: Text(pagina.text))
                   )
                ]
              )
          ],
        ),
      )
   );
  }
}