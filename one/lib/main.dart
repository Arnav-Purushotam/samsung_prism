import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:one/side_panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Image Upload'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? selectedImage;
  String message = "";
  String data_test = "";
  var data;

  getImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    selectedImage = File(pickedImage!.path);
    setState(() {});
  }

  uploadImage() async {
    final request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://93ad-2406-7400-73-90af-8ea-7913-689f-b028.in.ngrok.io /upload"));
    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile('image',
        selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
        filename: selectedImage!.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    message = resJson['message'];
    data = resJson['a'];
    //var num = data[0][0][0].toString();
    //data_test = num;
    data = data.toString();
    print(data);
    print(5);
    print(message);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            selectedImage == null
                ? Text("please select an image to upload")
                : Image.file(selectedImage!),
            TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: uploadImage,
                icon: const Icon(
                  Icons.upload_file,
                  color: Colors.white,
                ),
                label: Text(
                  "Upload",
                  style: TextStyle(color: Colors.white),
                )),
            Text(this.message),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: getImage, child: Icon(Icons.add_a_photo)),
    );
  }
}
