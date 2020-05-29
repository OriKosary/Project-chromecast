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
String host = "";
String message = "";
String hostForMessage = "";

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
    Socket.connect(host, port).then((socket) async {
      socket.write("client is connected");
    });
    _textController2.clear();
  }

  void _submitMsg3(String txt) {
    sendDataToType(_textController.text);
    _textController.clear();
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

  void moveRight() {
    Socket.connect(host, port).then((socket) async {
      socket.write("A4lt21");
    });
    socket.close();
  }


  void moveLeft() {
    Socket.connect(host, port).then((socket) async {
      socket.write("A4rt21");
    });
    socket.close();
  }

  void enter() {
    Socket.connect(host, port).then((socket) async {
      socket.write("S3hu22");
    });
    socket.close();
  }

  void delete() {
    Socket.connect(host, port).then((socket) async {
//      socket.write("S7tl23");
    });
    socket.close();
  }

//  bool movingUp = true;
//
//  void moveUpCon() {
//    movingUp = true;
//    Socket.connect(host, port).then((socket) async {
//      while(movingUp == true) {
//        socket.write("A4up21");
//      }
//    });
//    socket.close();
//  }
//
//  bool movingDown = true;
//
//  void moveDownCon() {
//    movingDown = true;
//    Socket.connect(host, port).then((socket) async {
//      while (movingDown == true) {
//        socket.write("A4dw21");
//      }
//    });
//    socket.close();
//  }
//
//  bool movingLeft = true;
//
//  void moveLeftCon() { // right left is opposite
//    movingLeft = true;
//    Socket.connect(host, port).then((socket) async {
//      while (movingLeft == true) {
//        socket.write("A4rt21");
//      }
//    });
//    socket.close();
//  }
//
//  bool movingRight = true;
//
//  void moveRightCon() {
//    movingRight = true;
//    Socket.connect(host, port).then((socket) async {
//      while (movingRight == true) {
//        Timer(Duration(seconds: 3), () {
//          socket.write("A4lt21");
//        });
//      }
//    });
//    socket.close();
//  }

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
                )
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                new Expanded(
                  child: CupertinoButton(child: Icon(CupertinoIcons.left_chevron, size: 100,), onPressed: () { moveLeft(); },),
                ),
                new Expanded(
                  child: CupertinoButton(child: Icon(CupertinoIcons.circle_filled, size: 100,), onPressed: () { click(); },),
                ),
                new Expanded(
                    child: CupertinoButton(child: Icon(CupertinoIcons.right_chevron, size: 100,), onPressed: () { moveRight(); },),
                  )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                new Expanded(
                  child: Text(' ')
                ),
                new Expanded(
                  child: CupertinoButton(child: Icon(CupertinoIcons.down_arrow, size: 100,), onPressed: () { moveDown(); },),
                ),
                new Expanded(
                  child: CupertinoButton(child: Icon(CupertinoIcons.back, size: 55), onPressed: () { delete(); },),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                new Flexible(
                  child: new CupertinoTextField(
                    controller: _textController, onSubmitted: _submitMsg3, decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1), borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                new Expanded(
                    child: new CupertinoButton(child: Text('Enter',), minSize: 55, onPressed: () { enter(); })
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}



