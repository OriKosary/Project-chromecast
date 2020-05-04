import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_ip/get_ip.dart';
import 'package:my_app/imgPicker.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoApp(
      home: HomeScreen(), // TODO: (work on theme) theme: CupertinoThemeData(),
    );
  }
}

String username = "Ori Kosary";
String host = "192.168.1.40";
String message = "";
String hostForMessage = "";

class Screenshotter extends State {

  noSuchMethod(Invocation i) => super.noSuchMethod(i);

  int _counter = 0;
  File _imageFile;
  // Future<File> _futureImage;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  // Gets screenshot
  File get_screen_shot() {
    Screenshot(
      controller: screenshotController,
    );
    screenshotController.capture().then((File image) {
      //Capture Done
      setState(() {
        _imageFile = image;
      });
    }).catchError((onError) {
      print(onError);
    });
    return _imageFile;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  bool lockDown = true; // this will be for the switch that only when it is on ill be able to send commands
  int port = 8200;
  Base64Encoder b64e = new Base64Encoder();
  Base64Decoder b64d = new Base64Decoder();

  final TextEditingController _textController = new TextEditingController();
  final TextEditingController _textController2 = new TextEditingController();
  final TextEditingController _textController3 = new TextEditingController();
  final TextEditingController _textController4 = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }

  Socket socket;

  void sendLocation(String location) {
    Socket.connect(host, port).then((socket) async {
        socket.write(location + ",Q3bv76"); // The string is a code to unlock move to location
    });
    socket.close();
  }

  void sendDataToType(String data) {
    Socket.connect(host, port).then((socket) async {
      socket.write(data + "P2lw60");
    });
    socket.close();
  }

  void click() {
    Socket.connect(host, port).then((socket) async {
      socket.write("B7kj89");
    });
    socket.close();
  }

  void _submitMsg(String txt) {
    sendLocation(_textController.text);
    _textController.clear();
  }

  void _submitMsg2(String txt) {
    host = _textController2.text;
    _textController2.clear();
  }

  void _submitMsg3(String txt) {
    sendDataToType(_textController3.text);
    _textController3.clear();
  }

  void moveUp() {
    Socket.connect(host, port).then((socket) async {
      socket.write("A4up21");
    });
    socket.close();
  }

  void moveDown() {
    Socket.connect(host, port).then((socket) async {
      socket.write("A4dw21");
    });
    socket.close();
  }

  void moveLeft() {
    Socket.connect(host, port).then((socket) async {
      socket.write("A4lt21");
    });
    socket.close();
  }

  void moveRight() {
    Socket.connect(host, port).then((socket) async {
      socket.write("A4rt21");
    });
    socket.close();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                new Flexible(
                  child: new CupertinoTextField(
                    controller: _textController2, onSubmitted: _submitMsg2, decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1), borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: CupertinoButton(child: Icon(CupertinoIcons.up_arrow, size: 100,), onPressed: () { moveUp(); },),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                new Flexible(
                  child: new CupertinoTextField(
                    controller: _textController, onSubmitted: _submitMsg, decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1), borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                new Expanded(
                  child: CupertinoButton(child: Icon(CupertinoIcons.play_arrow_solid, size: 100,), onPressed: () {click(); },)
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                new Flexible(
                  child: new CupertinoTextField(
                    controller: _textController3, onSubmitted: _submitMsg3, decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1), borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                new Expanded(
                    child: Text("here write if u want to type"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



