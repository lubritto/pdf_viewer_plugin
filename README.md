# Pdf Viewer Plugin

[![pub package](https://img.shields.io/pub/v/pdf_viewer_plugin.svg)](https://pub.dartlang.org/packages/pdf_viewer_plugin)

A Flutter plugin for IOS and Android providing a simple way to display PDFs.

## Features:

* Display PDF.

![android](assets/gifs/pdf_viewer_plugin_android.gif) ........... ![ios](assets/gifs/pdf_viewer_plugin_ios.gif)

## Installation

First, add `pdf_viewer_plugin` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

### iOS

Add one row to the `ios/Runner/info.plist`:

```
...

<key>io.flutter.embedded_views_preview</key>
<true/>
```

You need to 

### Example

Here is an example flutter app.

```dart
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String path;

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
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost() async {
    final response = await http.get(
        'https://expoforest.com.br/wp-content/uploads/2017/05/exemplo.pdf');
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  loadPdf() async {
    writeCounter(await fetchPost());
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
                Container(
                  height: 300.0,
                  child: PdfViewer(
                    filePath: path,
                  ),
                )
              else
                Text("Pdf is not Loaded"),
              RaisedButton(
                child: Text("Load pdf"),
                onPressed: loadPdf,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

[Feedback welcome](https://github.com/flutter/flutter/issues) and
[Pull Requests](https://github.com/flutter/plugins/pulls) are most welcome!
