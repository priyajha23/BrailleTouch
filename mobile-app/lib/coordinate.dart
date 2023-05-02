import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:vibration/vibration.dart';
class CordinatesBoard extends StatefulWidget {
  const CordinatesBoard({Key? key}) : super(key: key);

  @override
  State<CordinatesBoard> createState() => _CordinatesBoardState();
}

class _CordinatesBoardState extends State<CordinatesBoard> {
  static Future<void> vibrate() async {
    HapticFeedback.heavyImpact();
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('C-Board'),
      ),
      // body: PositionedTapDetector2(
      //   onTap: (position) =>{
      //     print('Single tap => '+position.global.toString()+" "+position.relative.toString())
      //   },
      //   onDoubleTap: (position) =>{
      //     print('Double tap => '+ position.global.toString()+" "+position.relative.toString())
      //   },
      //   onLongPress: (position) =>{
      //     print('Long press => '+ position.global.toString()+" "+position.relative.toString())
      //   },
      //   doubleTapDelay: Duration(milliseconds: 500),
      //   child: Image(
      //     image: AssetImage("assets/images/D1.jpeg"),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      body: GestureDetector(
        onPanUpdate: (details) async {
          int x=details.globalPosition.dx.toInt();
          int y=details.globalPosition.dy.toInt();
          print("Points Global => "+ details.globalPosition.dx.toInt().toString()+" "+details.globalPosition.dy.toInt().toString());
          //print("Points => "+ details.delta.dx.toString()+" "+details.delta.dy.toString());
          if((x>=39&&x<=90)&&(y>=123&&y<=186)){
            //Vibration.vibrate(amplitude: 128);
            // HapticFeedback.heavyImpact();
            Vibration.vibrate();
          }
          if((x>=239&&x<=322)&&(y>=128&&y<=195)){
            //HapticFeedback.heavyImpact();
            Vibration.vibrate();
          }
          if((x>=254&&x<=329)&&(y>=347&&y<=413)){
            //HapticFeedback.heavyImpact();
            Vibration.vibrate();
          }
        },
        child: Image(
          image: AssetImage("assets/images/D1.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
