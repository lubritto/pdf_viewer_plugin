import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String path;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.exists();
  }

  Future<Uint8List> fetchPost() async {
    // final response = await http.get(
    //     'https://expoforest.com.br/wp-content/uploads/2017/05/exemplo.pdf');
    final response = await http.get(
        'https://piktochart.com/wp-content/uploads/2016/05/Piktochart-e-book-2-Create-Your-First-Infographic-In-15-Minutes.pdf');
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  void loadPdf() async {
    await writeCounter(await fetchPost());
    await existsFile();
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              if (path != null)
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: PdfViewer(
                      filePath: path,
                      spacing: 10,
                      // uri:
                      //     'https://piktochart.com/wp-content/uploads/2016/05/Piktochart-e-book-2-Create-Your-First-Infographic-In-15-Minutes.pdf',
                    ),
                  ),
                )
              else
                Text("Pdf is not Loaded"),
              RaisedButton(
                child: Text("Load pdf"),
                onPressed: loadPdf,
                // onPressed: () {
                //   setState(() {});
                // },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
