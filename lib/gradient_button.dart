import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final List<Color>? colors;
  final GestureTapCallback? onPress;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Widget child;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  const GradientButton({Key? key,
    required this.child,
    this.colors,
    this.onPress,
    this.radius,
    this.padding,
    this.alignment,
    this.width,
    this.height
  }) : super(key: key);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {

    Widget current = widget.child;

    if(widget.alignment != null){
      current = Align(child: current,alignment: widget.alignment!,);
    }
    if(widget.padding != null){
      current = Padding(padding: widget.padding!,child: current,);
    }

    if(widget.height != null || widget.width != null){
      current =  ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: widget.height,width: widget.width),
        child: current
      );
    }
    current = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: widget.onPress,
        child: current,
        splashColor: widget.colors != null ? widget.colors!.first:null,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.radius ?? 0),
      ),
    );

    if(widget.colors != null || widget.radius != null){
      current = DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius ?? 0),
            gradient: widget.colors != null ? LinearGradient(colors: widget.colors!):null
        ),
        child: current,
      );
    }

    return current;
  }
}
