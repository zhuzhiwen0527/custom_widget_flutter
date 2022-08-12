import 'dart:async';

import 'package:custom_flutter/cavans_test.dart';
import 'package:custom_flutter/custom_segment_widget.dart';
import 'package:custom_flutter/gradient_button.dart';
import 'package:custom_flutter/gradient_custom_button.dart';
import 'package:custom_flutter/score_star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: GestureDetector(
    //     onTap: (){
    //       // debugDumpRenderTree();
    //       // debugDumpLayerTree();
    //       // debugDumpApp();
    //     },
    //     child: Container(
    //       color: Colors.purple,
    //     ),
    //   )
    // );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  int _counter = 0;
  int _index = 0;
  bool _start = false;
  void start() {
    if(!_start){
      _start = true;
      scheduleTick();
    } else {
      _start = false;
    }
  }
  int? _animationId;
  Duration? _startTime;
  void scheduleTick({ bool rescheduling = false }) {

    _animationId = SchedulerBinding.instance!.scheduleFrameCallback(_tick, rescheduling: false);
  }
  void _tick(Duration timeStamp) {
    _animationId = null;
    _startTime ??= timeStamp;
    _counter += 1;
    if(timeStamp - _startTime! >= const Duration(seconds: 1)){
      print("--------- frame  $_counter");
      _startTime = timeStamp;
      _counter = 0;

    }

    if(_start){
      scheduleTick(rescheduling: true);
    }

  }
  EdgeInsetsGeometry? _padding;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:  Container(
          margin: EdgeInsets.only(left: 50,right: 50),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              const CavansTest(),
              const SizedBox(height: 10,),
              CustomSwitchWidget(value: _index,
                leftTitle: "11",
                rightTitle: "22",
                height:45,
                textStyle: TextStyle(color: Colors.blueGrey,fontSize: 12),
                selectedTextStyle: TextStyle(color: Colors.white,fontSize: 12),
                onChange: (value){
                  _index = value;
                  setState(() {});
                },),
              const SizedBox(height: 10,),
              CustomSegmentWidget(
                leftTitle: "买入",
                rightTitle: "卖出",
                textStyle: TextStyle(color: Colors.blueGrey,fontSize: 12),
                selectedTextStyle: TextStyle(color: Colors.white,fontSize: 12),
                onChange: (value ) {
                  print("-------- value $value");
                },),
              const SizedBox(height: 10,),
              TextButton(onPressed: (){
                debugDumpLayerTree();
              }, child: Text("layer")),
              const SizedBox(height: 30,),
              ScoreStarWidget(),
              const SizedBox(height: 30,),
              GradientButton(
                padding: EdgeInsets.all(10),
                width: 200,
                height: 40,
                alignment: Alignment.center,
                child: Text("Tap"),
                colors: [Colors.blue,Colors.purple],
                radius: 8,
                onPress: (){
                  print("-----------------GradientButton");
                },),
              const SizedBox(height: 30,),
              GradientCustomButton(radius: 8,
                colors: [Colors.blue,Colors.purple],
                onPress: (){
                  print("----------------- GradientCustomButton");
                },
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                child: Text("button"),),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: start,
        tooltip: 'start',
        child: const Icon(Icons.not_started_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
