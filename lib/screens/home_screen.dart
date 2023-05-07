import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';

import '../provider/pdf_provider.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
              future: Provider.of<PDFProvider>(context, listen: true).selectPDFs(),
              builder: (context, snapshot) => 
              snapshot.data != null ?             
                CustomScrollView(
                    primary: false,
                    slivers: [         
                      SliverPadding(
                        padding: const EdgeInsets.all(15),
                        sliver: SliverGrid.count(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: [
                            for ( var i in snapshot.data! ) 
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<PDFProvider>(context, listen: false).changeSelectedPDF(i.path);
                                    Navigator.pushNamed(context, 'pdf_reader');
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Text(i.title),
                                      subtitle: Text(i.author),
                                    ),
                                  ),
                                )
                          ],
                        )
                      )
                    ])
                  : Text('')
          ),
          floatingActionButton: BotonSeleccionar(),
       ),
    );
  }
}

class BotonSeleccionar extends StatelessWidget {
  const BotonSeleccionar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
              onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowedExtensions: ['pdf'],
              type: FileType.custom,
            );
            if (result != null) {
              File file = File(result.files.single.path!);
              final bytes = await file.readAsBytes();
              PdfDocument doc = PdfDocument.fromBase64String(base64.encode(bytes));
              
              bool storagePermission = await Permission.storage.isGranted;

              if (!storagePermission) {
                storagePermission = await Permission.storage.request().isGranted;
              }
              if (await Permission.manageExternalStorage.request().isGranted) {
                if(storagePermission) {
                  const uuid = Uuid();
                  var v1 = uuid.v1();
                  Directory appDocDir = await getApplicationDocumentsDirectory();
                  await Directory('${appDocDir.path}/ebooks').create(recursive: true);
                  //ignore: use_build_context_synchronously
                  await context.read<PDFProvider>().insertDatabase(v1 , doc.documentInformation.title, doc.documentInformation.author);
      
                  await file.rename("${appDocDir.path}/ebooks/$v1.pdf");
                }
              }

              
   
             
              
   
              // print(utf8.decode(contents));
            } else {
              // User canceled the picker
            }
          },
              child: Text('Selecciona un pdf'),
    );
  }
}