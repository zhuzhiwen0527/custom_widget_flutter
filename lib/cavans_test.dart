
import 'package:flutter/material.dart';
import 'dart:math' as math;
class CavansTest extends StatefulWidget {
  const CavansTest({Key? key}) : super(key: key);

  @override
  State<CavansTest> createState() => _CavansTestState();
}

class _CavansTestState extends State<CavansTest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.grey,
      child: GestureDetector(
        child: CustomPaint(
          painter: CavansTestPaint(),
        ),
        onTap: (){

        },
      )
    );
  }
}


class CavansTestPaint extends CustomPainter{


  @override
  void paint(Canvas canvas, Size size) {


    // canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));

    final paint1 = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 100, 50), paint1);
    canvas.saveLayer(Rect.fromLTRB(0, 0, size.width, size.height), Paint()..color = Colors.white);
    // canvas.save();
    paint1.color = Colors.green;
    canvas.drawRect(const Rect.fromLTWH(0, 10, 100, 50), paint1);
    canvas.translate(-30, 0);
    // paint1.blendMode = BlendMode.srcOut;
    paint1.color = Colors.blue;
    canvas.drawRect(const Rect.fromLTWH(0, 20, 100, 50), paint1);
    canvas.restore();

    ///三阶贝塞尔曲线


    paint1.color = Colors.red;
    paint1.style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(0, 150);
    path.cubicTo(80, 150, 80, 130, 160, 130);
    canvas.drawPath(path, paint1);

    final gpaint1 = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final g  = LinearGradient(colors: [Colors.green,Colors.pink]);
    gpaint1.shader = g.createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, 150);
    path2.cubicTo(80, 150, 80, 130, 160, 130);
    path2.lineTo(160, size.height);
    path2.close();
    canvas.drawPath(path2, gpaint1);


    const RadialGradient gradient = RadialGradient(
      center: Alignment(1, -0.5), // near the top right
      radius: 0.6,
      colors: <Color>[
        Color(0xFFFFFF00), // yellow sun
        Color(0xFF0099FF), // blue sky
      ],
      stops: <double>[0.4, 1.0],
    );
    // rect is the area we are painting over
    final Paint paint = Paint()
      ..shader = gradient.createShader(const Rect.fromLTWH(100, 10, 50, 50));
    canvas.drawRect(const Rect.fromLTWH(100, 10, 50, 50), paint);

    const sweepGradient =  SweepGradient(
      center: FractionalOffset.center,
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors:<Color>[
         Color(0xFF4285F4), // blue
         Color(0xFF34A853), // green
         Color(0xFFFBBC05), // yellow
         Color(0xFFEA4335), // red
         Color(0xFF4285F4), // blue again to seamlessly transition to the start
      ],
      stops:<double>[0.0, 0.25, 0.5, 0.75, 1.0],
    );
    final spaint = Paint()
      ..shader = sweepGradient.createShader(Rect.fromLTWH(100, 80, 50, 50));
    canvas.drawRect(const Rect.fromLTWH(100, 80, 50, 50), spaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}