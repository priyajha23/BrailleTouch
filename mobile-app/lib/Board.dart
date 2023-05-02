
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:whiteboard/whiteboard.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  WhiteBoardController whiteBoardController =WhiteBoardController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board'),
        actions: [
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: WhiteBoard(
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
                  await ImageGallerySaver.saveImage(list);
                },
                // Callback common for redo or undo
                onRedoUndo: (t,m){},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
