import 'package:screenshot/screenshot.dart';
import 'package:compressimage/compressimage.dart';
import 'dart:io';

ScreenshotController screenshotController = ScreenshotController();

File _imageFile;

// Gets screenshot
File get_screen_shot() {
  Screenshot(
    controller: screenshotController,
  );
  screenshotController.capture().then((File image) {
    //Capture Done

    _imageFile = image;

  }).catchError((onError) {
    print(onError);
  });
  return _imageFile;
}

// Compress screenshot
Future compressNow() async {
  print("FILE SIZE BEFORE: " + _imageFile.lengthSync().toString());
  await CompressImage.compress(imageSrc: _imageFile.path, desiredQuality: 80); //desiredQuality ranges from 0 to 100
  print("FILE SIZE  AFTER: " + _imageFile.lengthSync().toString());
  return _imageFile;
}

// Will return the final product
File return_compressed_Img(){
  get_screen_shot();
  compressNow();
  return _imageFile;
}