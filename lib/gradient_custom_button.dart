import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class GradientCustomButton extends SingleChildRenderObjectWidget {
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final List<Color>? colors;
  final Function() onPress;
  final Color? splashColor;

  const GradientCustomButton(
      {Key? key,
      Widget? child,
      this.padding,
      this.radius,
      this.colors,
      required this.onPress,
      this.splashColor,
   })
      : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return GradientCustomButtonRenderObject(
        onPress: onPress,
        splashColor: splashColor,
        padding: padding ?? EdgeInsets.zero,
        radius: radius ?? 0,
        colors: colors ?? [],
        textDirection: Directionality.maybeOf(context));
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant GradientCustomButtonRenderObject renderObject) {
    renderObject
      ..onPress = onPress
      ..splashColor = splashColor
      ..padding = padding ?? EdgeInsets.zero
      ..textDirection = Directionality.maybeOf(context)
      ..radius = radius ?? 0
      ..colors = colors ?? [];
    super.updateRenderObject(context, renderObject);
  }
}

class GradientCustomButtonRenderObject extends RenderShiftedBox {
  Function() onPress;
  Color? splashColor;
  GradientCustomButtonRenderObject({
    required this.onPress,
    this.splashColor,
    Size preferredSize = Size.zero,
    double radius = 0,
    List<Color> colors = const [],
    RenderBox? child,
    EdgeInsetsGeometry? padding,
    TextDirection? textDirection,
  })  : assert(preferredSize != null),
        _padding = padding ?? EdgeInsets.zero,
        _radius = radius,
        _colors = colors,
        super(child);

  EdgeInsetsGeometry get padding => _padding;
  EdgeInsetsGeometry _padding;

  set padding(EdgeInsetsGeometry value) {
    assert(value != null);
    assert(value.isNonNegative);
    if (_padding == value) return;
    _padding = value;
    _markNeedResolution();
  }

  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;

  set textDirection(TextDirection? value) {
    if (_textDirection == value) return;
    _textDirection = value;
    _markNeedResolution();
  }

  EdgeInsets? _resolvedPadding;

  void _resolve() {
    if (_resolvedPadding != null) return;
    _resolvedPadding = padding.resolve(textDirection);
    assert(_resolvedPadding!.isNonNegative);
  }

  void _markNeedResolution() {
    _resolvedPadding = null;
    markNeedsLayout();
  }

  double get radius => _radius;
  double _radius;

  set radius(double value) {
    assert(value != null);
    if (radius == value) return;
    _radius = value;
    markNeedsLayout();
  }

  List<Color> get colors => _colors;
  List<Color> _colors;

  set colors(List<Color> value) {
    assert(value != null);
    if (colors == value) return;
    _colors = value;
    markNeedsPaint();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    _resolve();
    final double totalHorizontalPadding =
        _resolvedPadding!.left + _resolvedPadding!.right;
    final double totalVerticalPadding =
        _resolvedPadding!.top + _resolvedPadding!.bottom;
    if (child != null) {
      return child!.getMinIntrinsicWidth(
              max(0.0, height - totalVerticalPadding)) +
          totalHorizontalPadding;
    }
    return totalHorizontalPadding;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    _resolve();
    final double totalHorizontalPadding =
        _resolvedPadding!.left + _resolvedPadding!.right;
    final double totalVerticalPadding =
        _resolvedPadding!.top + _resolvedPadding!.bottom;
    if (child != null) {
      return child!.getMaxIntrinsicWidth(
              max(0.0, height - totalVerticalPadding)) +
          totalHorizontalPadding;
    }
    return totalHorizontalPadding;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    _resolve();
    final double totalHorizontalPadding =
        _resolvedPadding!.left + _resolvedPadding!.right;
    final double totalVerticalPadding =
        _resolvedPadding!.top + _resolvedPadding!.bottom;
    if (child != null) {
      return child!.getMinIntrinsicHeight(
              max(0.0, width - totalHorizontalPadding)) +
          totalVerticalPadding;
    }
    return totalVerticalPadding;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    _resolve();
    final double totalHorizontalPadding =
        _resolvedPadding!.left + _resolvedPadding!.right;
    final double totalVerticalPadding =
        _resolvedPadding!.top + _resolvedPadding!.bottom;
    if (child != null) {
      return child!.getMaxIntrinsicHeight(
              max(0.0, width - totalHorizontalPadding)) +
          totalVerticalPadding;
    }
    return totalVerticalPadding;
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      circleCenter = event.localPosition;
      _start = true;
      _stop = false;
      scheduleTick();
    } else if (event is PointerUpEvent) {
      _start = false;
      _stop = true;
      onPress.call();
    }
    super.handleEvent(event, entry);
  }

  Offset circleCenter = Offset.zero;

  bool _start = false;
  bool _stop = false;

  double _splashRadius = 0;

  void scheduleTick({bool rescheduling = false}) {
    SchedulerBinding.instance!
        .scheduleFrameCallback(_tick, rescheduling: rescheduling);
  }

  void _tick(Duration timeStamp) {
    final maxRadius = max(size.width, size.height);
    if (_stop) {
      _splashRadius += _splashRadius / 3;
    } else {
      _splashRadius += 1.5;
    }
    if (_splashRadius > maxRadius && _stop) {
      _stop = false;
      _splashRadius = 0;
    }
    markNeedsPaint();
    if (_start || _stop) {
      scheduleTick(rescheduling: true);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    context.canvas.clipRect(rect);

    final paint = Paint()..style = PaintingStyle.fill;
    if (colors.isNotEmpty) {
      paint.shader = LinearGradient(colors: colors).createShader(rect);
    } else {
      paint.color = Colors.white;
    }
    context.canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius)), paint);

    if (_splashRadius != 0) {
      final circlePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = splashColor ?? Colors.cyan;
      context.canvas.drawCircle(circleCenter, _splashRadius, circlePaint);
    }
    context.canvas.restore();
    super.paint(context, offset);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    _resolve();
    assert(_resolvedPadding != null);
    if (child == null) {
      return constraints.constrain(Size(
        _resolvedPadding!.left + _resolvedPadding!.right,
        _resolvedPadding!.top + _resolvedPadding!.bottom,
      ));
    }
    final BoxConstraints innerConstraints =
        constraints.deflate(_resolvedPadding!);
    final Size childSize = child!.getDryLayout(innerConstraints);
    return constraints.constrain(Size(
      _resolvedPadding!.left + childSize.width + _resolvedPadding!.right,
      _resolvedPadding!.top + childSize.height + _resolvedPadding!.bottom,
    ));
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    _resolve();
    assert(_resolvedPadding != null);
    if (child == null) {
      size = constraints.constrain(Size(
        _resolvedPadding!.left + _resolvedPadding!.right,
        _resolvedPadding!.top + _resolvedPadding!.bottom,
      ));
      return;
    }
    final BoxConstraints innerConstraints =
        constraints.deflate(_resolvedPadding!);
    child!.layout(innerConstraints, parentUsesSize: true);
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset =
        Offset(_resolvedPadding!.left, _resolvedPadding!.top);
    size = constraints.constrain(Size(
      _resolvedPadding!.left + child!.size.width + _resolvedPadding!.right,
      _resolvedPadding!.top + child!.size.height + _resolvedPadding!.bottom,
    ));
  }
}
