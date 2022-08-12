import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/rendering.dart';

class ScoreStarWidget extends LeafRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return ScoreStarRender();
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant ScoreStarRender renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}

class ScoreStarRender extends RenderBox {

  Color _backgroundColor = Colors.grey;

  set backgroundColor(value) {
    if (value == _backgroundColor) return;
    _backgroundColor = value;
    markNeedsPaint();
  }

  Color _foregroundColor = Colors.red;

  set foregroundColor(value) {
    if (value == _foregroundColor) return;
    _foregroundColor = value;
    markNeedsPaint();
  }

  double _score = 3.0;

  set score(value) {
    if (_score == value) return;
    _score = value;
    markNeedsPaint();
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return constraints.biggest.width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return constraints.biggest.width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    double height =
        min(constraints.biggest.height, constraints.biggest.width / 5);
    height = max(height, constraints.smallest.height);
    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    double height =
        min(constraints.biggest.height, constraints.biggest.width / 5);
    height = max(height, constraints.smallest.height);
    return height;
  }


  @override
  bool hitTestSelf(Offset position) => true;
  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {

    print("$event");
  }

  @override
  void performLayout() {
    double height =
        min(constraints.biggest.height, constraints.biggest.width / 5);
    height = max(constraints.smallest.height, height);
    size = constraints.constrain(Size(constraints.biggest.width, height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {

      _backgroundStarPaint(context, offset);
      context.pushClipRect(needsCompositing, offset,Rect.fromLTWH(0, 0, size.width * _score/5, size.height),_foregroundStarPaint);
  }

  void _backgroundStarPaint(PaintingContext context, Offset offset){
      _starPainter(context, offset, _backgroundColor);
  }
  void _foregroundStarPaint(PaintingContext context, Offset offset){
    _starPainter(context, offset, _foregroundColor);
  }

  void _starPainter(PaintingContext context, Offset offset, Color color) {
    Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    double radius = min(size.height / 2, size.width / (2 * 5));

    Path path = Path();
    _addStarLine(radius, path);
    for (int i = 0; i < 4; i++) {
      path = path.shift(Offset(radius * 2, 0.0));
      _addStarLine(radius, path);
    }

    path = path.shift(offset);
    path.close();

    context.canvas.drawPath(path, paint);
  }

  void _addStarLine(double radius, Path path) {
    double radian = (pi * 36) / 180;

    double sinRadian = sin(radian);
    double sinHalfRadian = sin(radian / 2);

    double cosRadian = cos(radian);
    double cosHalfRadian = cos(radian / 2);

    double innerRadius = (radius * sinHalfRadian / cosRadian);

    path.moveTo((radius * cosHalfRadian), 0.0);
    path.lineTo((radius * cosHalfRadian + innerRadius * sinRadian),
        (radius - radius * sinHalfRadian));
    path.lineTo(
        (radius * cosHalfRadian * 2), (radius - radius * sinHalfRadian));
    path.lineTo((radius * cosHalfRadian + innerRadius * cosHalfRadian),
        (radius + innerRadius * sinHalfRadian));
    path.lineTo((radius * cosHalfRadian + radius * sinRadian),
        (radius + radius * cosRadian));
    path.lineTo((radius * cosHalfRadian), (radius + innerRadius));
    path.lineTo((radius * cosHalfRadian - radius * sinRadian),
        (radius + radius * cosRadian));
    path.lineTo((radius * cosHalfRadian - innerRadius * cosHalfRadian),
        (radius + innerRadius * sinHalfRadian));
    path.lineTo(0.0, (radius - radius * sinHalfRadian));
    path.lineTo((radius * cosHalfRadian - innerRadius * sinRadian),
        (radius - radius * sinHalfRadian));
  }
}
