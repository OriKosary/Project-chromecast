import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_ip/get_ip.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoApp(
      home: HomeScreen(),
    );
  }
}

// TODO : build a Client who will send the image
class Client extends Screenshotter {

//  static String ip = getAddress(); // This will be the server ip, '''don't forget to display it'''
  int port = 8200;
//  InternetAddress address = InternetAddress('127.0.0.1');
  Screenshotter s = new Screenshotter();

  Socket socket;
  Base64Encoder b64e = new Base64Encoder();

  File _pickedImage;

  Future getImageFromCamera() async {

    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _pickedImage = image;
    });
  }

  Future getImageFromGallery() async {

    final file = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(file != null) {
      setState(() => _pickedImage = file);
    }

  }

  void main() {
    Socket.connect("192.168.1.40", port).then((socket) {
//    var img = s.return_compressed_Img();
//    List<int> imageBytes1 = img.readAsBytesSync();
//    String imgInString = b64e.convert(imageBytes1);
//    socket.write(imgInString);
//    String str = 'hello this is ori and i am proving that this works';
//    socket.write(str);
//    socket.write("data");
      //   File img = s.get_screen_shot();
      getImageFromGallery();
      if (_pickedImage != null) {
        socket.write(_pickedImage);
      }
    });
    socket.close();
  }

}

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

class HomeScreen extends StatelessWidget {

  noSuchMethod(Invocation i) => super.noSuchMethod(i);
//  State<HomeScreen>();

  // Gets Ip
  Future<String> getIP() async {
    return GetIp.ipAddress;
  }

  @override
  Widget build(BuildContext context) {
    String ipAddress = getIP().toString();
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                title: Text('Home')
            ),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                title: Text('Profile')
            ),
          ],
        ),
        tabBuilder: (context, i){
          return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: (i == 0) ? Text('Home') : Text('Profile'),
                    ),
                    // TODO : Here i will put a diffrent parameter for the condition!!!!!
                    child: Center(
                      //need to do if/else statement to declare what name to do for each button
                        child: (i == 0) ?
                        CupertinoButton(
                          //TODO : Here just switch the text to icon and use the right paramaters
                          // Text('Button for Server', style : CupertinoTheme.of(context).textTheme.actionTextStyle.copyWith(fontSize: 32)),
                          child: Icon(CupertinoIcons.play_arrow_solid, size: 180.0),
                          // TODO : need to do if/else statement to declare what function to do for each button
                          onPressed: () {
                            // START STREAMING
                            Client().main();
                          }, // TODO : need to figure out how to work with future, and how to write more then 1 line
                        ) : Text('Ipv4 : $ipAddress' , style: CupertinoTheme.of(context).textTheme.actionTextStyle.copyWith(fontSize: 32),)
                    )
                );
              }
          );
        }
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen(this.topic);

  final String topic;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Details'),
      ),
      child: Center(
        // TODO : here will be the condition statement
        child: Text(
          'Details for $topic',
          style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
        ),
      ),
    );
  }
}

//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
//        primarySwatch: Colors.blue,
//      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  // This widget is the home page of your application. It is stateful, meaning
//  // that it has a State object (defined below) that contains fields that affect
//  // how it looks.
//
//  // This class is the configuration for the state. It holds the values (in this
//  // case the title) provided by the parent (in this case the App widget) and
//  // used by the build method of the State. Fields in a Widget subclass are
//  // always marked "final".
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // This method is rerun every time setState is called, for instance as done
//    // by the _incrementCounter method above.
//    //
//    // The Flutter framework has been optimized to make rerunning build methods
//    // fast, so that you can just rebuild anything that needs updating rather
//    // than having to individually change instances of widgets.
//    return Scaffold(
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),
//      body: Center(
//        // Center is a layout widget. It takes a single child and positions it
//        // in the middle of the parent.
//        child: Column(
//          // Column is also a layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug painting" (press "p" in the console, choose the
//          // "Toggle Debug Paint" action from the Flutter Inspector in Android
//          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//          // to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have clicked the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}
