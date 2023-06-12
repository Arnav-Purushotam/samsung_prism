import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
// import 'package:flutter_js/flutter_js.dart';
// import 'package:flutter_js/javascript_runtime.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:one/side_panel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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

  final url = 'http://192.168.1.114:9000/upload-image';
  final headers = {"Content-type": "application/json"};
  uploadImage() async {

    final bytes = await selectedImage!.readAsBytes();
    final base64Image = base64Encode(bytes);
    final body = jsonEncode({'image': base64Image});

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      message = data['message'];
    } else {
      message = 'Request failed with status: ${response.statusCode}.';
    }

    // getData();
    setState(() {});
  }
  getData() async {
    final response = await http.get(Uri.parse('http://192.168.1.114:9000/get-3Dobject'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      File file = File('Objects/object.obj');
      file.writeAsString(data['object']);
      print(data['object']);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
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
