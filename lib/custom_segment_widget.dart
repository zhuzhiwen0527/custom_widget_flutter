
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';


class CustomSwitchWidget extends LeafRenderObjectWidget{
  final Color leftSelectedColor;
  final Color rightSelectedColor;
  final Color normalColor;
  final String leftTitle;
  final String rightTitle;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final double radius;
  final Function(int) onChange;
  final int value;
  final double height;
  const CustomSwitchWidget({
    Key? key,
    this.leftSelectedColor = Colors.green,
    this.rightSelectedColor = Colors.red,
    this.normalColor = Colors.grey,
    this.leftTitle = "",
    this.rightTitle = "",
    this.textStyle,
    this.selectedTextStyle,
    this.radius = 5,
    this.height = 40,
    required this.value,
    required this.onChange
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CustomSwitchRenderObject(
        leftSelectedColor: leftSelectedColor,
        rightSelectedColor: rightSelectedColor,
        normalColor: normalColor,
        leftTitle: leftTitle,
        rightTitle: rightTitle,
        textStyle: textStyle,
        selectedTextStyle: selectedTextStyle,
        radius: radius,
        height: height,
        value: value,
        onChange: onChange,

    );
  }

  @override
  void updateRenderObject(BuildContext context,  _CustomSwitchRenderObject renderObject) {

    renderObject
      ..leftSelectedColor = leftSelectedColor
      ..rightSelectedColor = rightSelectedColor
      ..normalColor = normalColor
      ..leftTitle = leftTitle
      ..rightTitle = rightTitle
      ..textStyle = textStyle
      ..selectedTextStyle = selectedTextStyle
      ..radius = radius
      ..height = height
      ..value = value
      ..onChange = onChange;
  }

}

class _CustomSwitchRenderObject extends RenderBox{

   Color leftSelectedColor;
   Color rightSelectedColor;
   Color normalColor;
   String leftTitle;
   String rightTitle;
   TextStyle? textStyle;
   TextStyle? selectedTextStyle;
   double radius;
   Function(int) onChange;


   double offsetX = 10;

  _CustomSwitchRenderObject({
    this.leftSelectedColor = Colors.green,
    this.rightSelectedColor = Colors.red,
    this.normalColor = Colors.grey,
    this.leftTitle = "",
    this.rightTitle = "",
    this.textStyle,
    this.selectedTextStyle,
    this.radius = 5,
    double height = 40,
    required int value,
    required this.onChange
  }): _value = value,_height = height;
   int _value;
  set value(int val){
      if(_value == val) return;
      _value = val;
      markNeedsPaint();
  }
   double? _height;
   set height(double val){
     if(_height == val) return;
     _height = val;
     markNeedsLayout();
   }
  int get value => _value;
  Path? _path;
  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {

    if(event is PointerDownEvent && _path != null){
      final offset  = event.localPosition;
      onChange(_path!.contains(offset) ? 0 : 1);
    }

  }
  @override
  void paint(PaintingContext context, Offset offset) {
    // path 偏移
    // Rect rect = offset & size;
    // double t = rect.top;
    // double l = rect.left;
    // double h = rect.height;
    // double w = rect.width;
    // double centerX = size.width/2.0 + l;
    // double centerY = size.height/2.0 + t;

    double t = 0;
    double l = 0;
    double h = size.height;
    double w = size.width;
    double centerX = size.width/2.0;
    double centerY = size.height/2.0;

    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);
    ///裁剪 圆角
    context.canvas.clipRRect(RRect.fromRectAndRadius(Rect.fromLTWH(t, l, w, h), Radius.circular(radius)));

    Color p1 = leftSelectedColor ;
    Color p2 = normalColor;

    if(value == 1){
      p1 = normalColor;
      p2 = rightSelectedColor;
    }

    Path path = Path();
    // 路径移动至起点
    path.moveTo(t ,l);
    // 连接各个端点
    path.lineTo(centerX + offsetX,t);
    path.lineTo(centerX - offsetX,h);
    path.lineTo(l,h);
    path.close();
    _path = path;

    final Paint paint = Paint()
      ..blendMode = BlendMode.src
      ..isAntiAlias = true
      ..color = p2
      ..style = PaintingStyle.fill;

    // 绘制背景
    context.canvas.drawPaint(paint);

    // 绘制路径
    paint.color = p1;
    context.canvas.drawPath(path, paint);

    // 绘制文字
    TextSpan span = TextSpan(
        children: [
          TextSpan(
              text: leftTitle,
              style: value == 0 ? selectedTextStyle:textStyle
          ),
        ]
    );
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(context.canvas, Offset(centerX - size.width/4 -  tp.width/2, centerY - tp.height/2));

    // 绘制文字
    TextSpan span1 = TextSpan(
        children: [
          TextSpan(
              text: rightTitle,
              style: value == 1 ? selectedTextStyle:textStyle
          ),
        ]
    );
    TextPainter tp1 = TextPainter(text: span1, textDirection: TextDirection.ltr);
    tp1.layout();
    tp1.paint(context.canvas, Offset(centerX + size.width/4  -  tp1.width/2, centerY - tp1.height/2));
    context.canvas.restore();
  }

  // @override
  // bool get sizedByParent => true;

  // @override
  // void performResize() {
  //   print("---------------- performResize");
  //   super.performResize();
  // }
  //
  // @override
  // Size computeDryLayout(BoxConstraints constraints) {
  //
  //   return constraints.constrain(Size.fromHeight(_height));
  // }
  @override
  void performLayout() {
    size = constraints.constrain(_height != null?Size.fromHeight(_height!):Size.infinite);
  }

}

class CustomSegmentWidget extends StatefulWidget {

  final Color leftSelectedColor;
  final Color rightSelectedColor;
  final Color normalColor;
  final String leftTitle;
  final String rightTitle;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final double radius;
  final Function(int) onChange;
  const CustomSegmentWidget({Key? key,
    this.leftSelectedColor = Colors.green,
    this.rightSelectedColor = Colors.red,
    this.normalColor = Colors.grey,
    this.leftTitle = "",
    this.rightTitle = "",
    this.radius = 5,
    required this.onChange,
    this.textStyle,
    this.selectedTextStyle,
  }) : super(key: key);

  @override
  State<CustomSegmentWidget> createState() => _CustomSegmentWidgetState();
}

class _CustomSegmentWidgetState extends State<CustomSegmentWidget> {
  Offset? _offset;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp:(TapUpDetails details){
        setState(() {
          _offset = details.localPosition;
        });
      },
      child: Container(
        height: 45,
        color: Colors.transparent,
        child: CustomPaint(
          size:const Size(double.infinity, double.infinity),
          painter: _SegmentPainter(offsetX: 10,
              offset: _offset,
              radius: widget.radius,
              leftTitle: widget.leftTitle,
              rightTitle: widget.rightTitle,
              rightSelectedColor: widget.rightSelectedColor,
              leftSelectedColor: widget.leftSelectedColor,
              textStyle: widget.textStyle,
              selectedTextStyle: widget.selectedTextStyle,
              selectedCallBack: widget.onChange),
        ),
      ),
    );
  }
}


class _SegmentPainter extends CustomPainter{

  final Color leftSelectedColor;
  final Color rightSelectedColor;
  final Color normalColor;
  final String leftTitle;
  final String rightTitle;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  Offset? offset;
  double offsetX;
  final double radius;
  Function(int) selectedCallBack;
  _SegmentPainter({required this.offsetX,
    this.offset,
    required this.selectedCallBack,
    this.radius = 5,
    this.leftSelectedColor = Colors.green,
    this.rightSelectedColor = Colors.red,
    this.normalColor = Colors.grey,
    this.rightTitle = '',
    this.leftTitle = '',
    this.textStyle,
    this.selectedTextStyle
  });
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width/2.0;
    double h = size.height;
    double w = size.width;
    ///裁剪 圆角
    canvas.clipRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), Radius.circular(radius)));
    Path path1 = Path();
    // 路径移动至起点
    path1.moveTo(centerX + offsetX,0);
    // 连接各个端点
    path1.lineTo(centerX - offsetX,h);
    path1.lineTo(0,h);
    path1.lineTo(0,0);
    path1.close();

    int _index = 0;
    if(offset != null && !path1.contains(offset!)){
      _index = 1;
    }

    Color p1 = leftSelectedColor ;
    Color p2 = normalColor;

    if(_index == 1){
      p1 = normalColor;
      p2 = rightSelectedColor;
    }

    final Paint paint = Paint()
      ..color = p2
      ..style = PaintingStyle.fill;

    canvas.drawPaint(paint);

    paint.color = p1;
    // 绘制路径
    canvas.drawPath(path1, paint);

    // drawParagraph 绘制文字
    final ts = _index == 0 ? selectedTextStyle:textStyle;
    final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle());
    if(ts != null){
      paragraphBuilder.pushStyle(ts.getTextStyle());
    }
    paragraphBuilder.addText(leftTitle);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: size.width/2));
    canvas.drawParagraph(paragraph, Offset(centerX/2 - paragraph.longestLine/2, h/2 - paragraph.height/2));

    // 绘制文字
    TextSpan span1 = TextSpan(
        children: [
          TextSpan(
              text: rightTitle,
              style: _index == 1 ? selectedTextStyle:textStyle
          ),
        ]
    );
    TextPainter tp1 = TextPainter(text: span1, textDirection: TextDirection.ltr);
    tp1.layout();
    tp1.paint(canvas, Offset(w - centerX/2  -  tp1.width/2, h/2 - tp1.height/2));
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}