import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as st;
import 'package:http/http.dart' as http;

class SpeechWriting extends StatefulWidget {
  late String writings;
  SpeechWriting(String writings){
    this.writings=writings;
  }

  @override
  State<SpeechWriting> createState() => _SpeechWritingState(writings);
}

class _SpeechWritingState extends State<SpeechWriting> {
  late String writings;
  _SpeechWritingState(String writings){
    this.writings=writings;
  }
  st.SpeechToText _speechToText = st.SpeechToText();
  String text="";
  bool isinit=false;
  void _initSpeech() async {
    bool v=await _speechToText.initialize(debugLogging: true);
    setState(() {
      isinit=v;
    });
  }
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      text = result.recognizedWords;
    });
  }

  void sendToDatabase(String writings) async{
    String putbaseUrl="https://braille-70ade-default-rtdb.firebaseio.com/Prototype.json";
    final body={
      'Data':writings
    };
    final response=await http.put(Uri.parse(putbaseUrl),headers: { 'Content-Type':'application/json' },
        body: jsonEncode(body)
    );
    print(response.body.toString());
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      status="Not Listening";
      writings=writings+text;
      sendToDatabase(writings);
    });
  }
  String status="Not Listening";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeech();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(status,style: TextStyle(color: Colors.black)),
          SizedBox(
            height: 10,
          ),
          Text(isinit.toString(),style: TextStyle(color: Colors.black)),
          SizedBox(
            height: 10,
          ),
          Text(writings,style: TextStyle(color: Colors.black)),
          SizedBox(
            height: 200,
          ),
          GestureDetector(
            onLongPressStart: (details)async {
              setState(() {
                text="";
                status="Listening";
              });
              await _speechToText.listen(onResult: _onSpeechResult);
            },
            onLongPressEnd: (details){
              _stopListening();
            },
            child: ElevatedButton(
                onPressed: () {

                },
                child: Text('Long Press',style: TextStyle(color: Colors.black),)
            ),
          )
        ],
      ),
    );
  }
}
