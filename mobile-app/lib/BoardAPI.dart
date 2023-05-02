
import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';

import 'package:braille/coordinate.dart';
import 'package:braille/pdftoaudio.dart';
import 'package:braille/writing_by_speech.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whiteboard/whiteboard.dart';
import 'package:http/http.dart' as http;

class BoardAPI extends StatefulWidget {
  const BoardAPI({Key? key}) : super(key: key);

  @override
  State<BoardAPI> createState() => _BoardAPIState();
}

class _BoardAPIState extends State<BoardAPI> {

  void getEnglishAlphabet(Uint8List list) async {

    try{

      //String baseUrl="http://braille23.pythonanywhere.com/upload";//logistic regression
      String baseUrl="http://shuvam23dotrec.pythonanywhere.com/predict";//deep learning
      String base64=base64Encode(list);
      // final body={
      //   "image":base64
      // };
      Map<String, String> heads = {
        "Content-type": 'application/json',
      };
      var request = new http.MultipartRequest("POST", Uri.parse(baseUrl));
      request.headers.addAll(heads);
      request.fields['image']=base64;
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) async {
        print("Response => "+value);
        var data=jsonDecode(value);
        print("Output => "+data['class']);

        String putbaseUrl="https://braille-70ade-default-rtdb.firebaseio.com/Prototype.json";
        writings=writings+data['class'].toString();
        final body={
          'Data':writings
        };
        final response=await http.put(Uri.parse(putbaseUrl),headers: { 'Content-Type':'application/json' },
            body: jsonEncode(body)
        );

      });


    }catch(e){
      print("API Error => "+e.toString());
    }

  }

  WhiteBoardController whiteBoardController =WhiteBoardController();
  late Uint8List fileData;
  String writings="";

  void getDataBaseLastData() async{
    String baseUrl="https://braille-70ade-default-rtdb.firebaseio.com/Prototype.json";
    final response;
    try{

      response=await http.get(Uri.parse(baseUrl),headers: { 'Content-Type':'application/json' });
      var data=jsonDecode(response.body.toString());
      print("Get Data => "+data['Data'].toString());
      if(data['Data'].toString()!="Empty"){
        setState(() {
          writings=data['Data'].toString();
        });
      }

    }catch(e){
      print("DataError => "+e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDataBaseLastData();

  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CordinatesBoard()));
          },
              child: Text('Touch',style: TextStyle(color: Colors.black),)
          ),
          TextButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AudioPDF()));
          },
              child: Text('Reading',style: TextStyle(color: Colors.black),)
          ),
          TextButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SpeechWriting(writings)));
          },
              child: Text('SpeechText',style: TextStyle(color: Colors.black),)
          ),
          TextButton(onPressed: (){
            whiteBoardController.convertToImage();
          },
              child: Text('Save',style: TextStyle(color: Colors.black),)
          ),
          TextButton(onPressed: (){
            whiteBoardController.clear();
          },
              child: Text('clear',style: TextStyle(color: Colors.black),)
          )
        ],
      ),
      body:WhiteBoard(
          // background Color of white board
          backgroundColor: Colors.white,
          // Controller for action on whiteboard
          controller: whiteBoardController,
          // Stroke width of freehand
          strokeWidth: 69,
          // Stroke color of freehand
          strokeColor: Colors.black,
          // For Eraser mode
          isErasing: false,
          // Save image
          onConvertImage: (list) async {
            // Uint8List resizedData = list;
            // IMG.Image? img = IMG.decodeImage(list);
            // IMG.Image resized = IMG.copyResize(img!, width: 232, height: 407);
            // resizedData = IMG.encodeJpg(resized);
            //await ImageGallerySaver.saveImage(resizedData);
            setState(() {
              fileData=list;
              print(fileData.toString());
              getEnglishAlphabet(fileData);
            });

            //await ImageGallerySaver.saveImage(file.readAsBytesSync());
          },
          // Callback common for redo or undo
          onRedoUndo: (t,m){

          },
        ),
    );
  }
}
