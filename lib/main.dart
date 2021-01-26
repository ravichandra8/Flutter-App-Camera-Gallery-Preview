

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  final picker = ImagePicker();
  final List<String> photoChooser = <String>[
    'Take a photo',
    'Choose from Gallery',
    'Remove image'
  ];

  Future getImagefromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile == null) {
      return;
    }
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImagefromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future removeImage() async {
    setState(() {
      _image = null;
    });
  }


  @override
  Widget build(BuildContext context) {
   return Material(
     child:  Scaffold(
      appBar: AppBar(title: Text("CameraGalleryExample"),),
       body:    GestureDetector(
         child: Padding(
           padding: const EdgeInsets.all(8.0),
           child:Center(
             child:  Container(
               width: 240,
               height: 240,
               child: CircleAvatar(
                 radius: 155,
                 backgroundColor: Colors.white,
                 child: _image == null
                     ? Icon(Icons.account_circle,size:100,)
                     : CircleAvatar(
                   radius: 150,
                    backgroundImage:
                    Image.file(_image).image,
                 ),
               ),
             ),
           ),

         ),
         onTap: () {
           showModalBottomSheet<void>(
               context: context,
               builder: (BuildContext context) {
                 return Container(
                   height: 150,
                   child: ListView.separated(
                     padding: const EdgeInsets.all(8),
                     itemCount: photoChooser.length,
                     itemBuilder:
                         (BuildContext context, int index) =>
                         InkWell(
                           onTap: () {
                             if (index == 0) {
                               getImagefromCamera();
                             } else if (index == 1) {
                               getImagefromGallery();
                             } else{
                               removeImage();
                             }
                             Navigator.pop(context);
                           },
                           child: Container(
                             height: 33,
                             alignment: Alignment.centerLeft,
                             child: Text(
                               '${photoChooser[index]}',
                               style: TextStyle(fontSize: 16.0),
                             ),
                           ),
                         ),
                     separatorBuilder:
                         (BuildContext context, int index) =>
                     const Divider(),
                   ),
                 );
               });
         },
       ),
     ),
   );
  }

}
