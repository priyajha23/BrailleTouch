

import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:flutter_tts/flutter_tts.dart';//text to speech

class AudioPDF extends StatefulWidget {
  const AudioPDF({Key? key}) : super(key: key);

  @override
  State<AudioPDF> createState() => _AudioPDFState();
}

class _AudioPDFState extends State<AudioPDF> {

  String pdfText="";
  FlutterTts flutterTts = FlutterTts();

  void generateText(String path) async{
    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(path);
      setState(() {
        pdfText=text;
        SpeakText(pdfText);
      });

    } on PlatformException {
      print('Failed to get PDF text.');
    }
  }

  void SpeakText(String text) async{
    List<dynamic> languages = await flutterTts.getLanguages;
    print("Languages => "+languages.toString());
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
    await flutterTts.speak(text);
  }

  void getPdfFile() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: ['pdf']);
    if (result != null) {
      if(result.files.single.path!=null){
        File file = File(result.files.single.path!);
        Uint8List fileBytes=file.readAsBytesSync();
        String pdfbase64=base64Encode(fileBytes);
        generateText(result.files.single.path!);
      }
    } else {
      // User canceled the picker
      print("FILE PICK CANCELLED");
    }
  }

  @override
  void initState() {
    super.initState();
    getPdfFile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: (){
            getPdfFile();
          },
              child: Text(
                'Pick File',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
              )
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            pdfText,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
