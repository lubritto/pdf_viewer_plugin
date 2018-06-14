import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  initState() {
    super.initState();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/teste.pdf');
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
  final response =
      await http.get('https://expoforest.com.br/wp-content/uploads/2017/05/exemplo.pdf');
  final responseJson = response.bodyBytes;

  return responseJson;
}

  initPlatformState() async {
    String platformVersion;
    try {

      writeCounter(await fetchPost());
      var x = await existsFile();
      PdfViewerPlugin.getPdfViewer((await _localFile).path, 80, 200, 200);

    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted)
      return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Column(children: <Widget>[
              new Text("Hello"),
              new RaisedButton(
                child: new Text("Clique aqui"),
                onPressed: initPlatformState
              ),
          ],) 
        ),
      ),
    );
  }
}
