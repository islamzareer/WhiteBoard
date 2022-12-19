import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:white_board/drawing_painter.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  double opacity = 1.0;
  bool showBottomList = false;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.strokeWidth;
  List<DrawingPoints> points = [];
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Here is your wide Space..."),
            backgroundColor: Colors.deepPurple,
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      showBottomList = false;
                      points.clear();
                    });
                  },
                  child: const Text(
                    "Clear    ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ]),
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.deepPurple),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: showBottomList,
                  child: (selectedMode == SelectedMode.color)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: getColorList(),
                        )
                      : Slider(
                          value: (selectedMode == SelectedMode.strokeWidth)
                              ? strokeWidth
                              : opacity,
                          max: (selectedMode == SelectedMode.strokeWidth)
                              ? 50.0
                              : 1.0,
                          min: 0.0,
                          onChanged: (val) {
                            setState(() {
                              if (selectedMode == SelectedMode.strokeWidth) {
                                strokeWidth = val;
                              } else {
                                opacity = val;
                              }
                            });
                          }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.notes),
                        onPressed: () {
                          setState(() {
                            if (selectedMode == SelectedMode.strokeWidth) {
                              showBottomList = !showBottomList;
                            }
                            selectedMode = SelectedMode.strokeWidth;
                          });
                        }),
                    IconButton(
                        icon: const Icon(Icons.opacity),
                        onPressed: () {
                          setState(() {
                            if (selectedMode == SelectedMode.opacity) {
                              showBottomList = !showBottomList;
                            }
                            selectedMode = SelectedMode.opacity;
                          });
                        }),
                    IconButton(
                        icon: const Icon(Icons.color_lens),
                        onPressed: () {
                          setState(() {
                            if (selectedMode == SelectedMode.color) {
                              showBottomList = !showBottomList;
                            }
                            selectedMode = SelectedMode.color;
                          });
                        }),
                    IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            selectedColor = Colors.white;
                          });
                        }),
                    IconButton(
                        icon: const Icon(Icons.undo),
                        onPressed: () {
                          setState(() {
                            if (points.isNotEmpty) {
                              points.removeLast();
                            }
                          });
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;

              points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth));
            });
          },
          onPanStart: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth));
            });
          },
          onPanEnd: (details) {
            setState(() {
              points.add;
            });
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawingPainter(
              pointsList: points,
            ),
          ),
        ),
      ),
    );
  }

  getColorList() {
    List<Widget> listWidget = [];
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          builder: (context) => AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Got it'),
                onPressed: () {
                  setState(() => selectedColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          context: context,
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 20.0),
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.white, Colors.black, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );

    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          height: 35,
          width: 35,
          color: color,
        ),
      ),
    );
  }
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({required this.paint, required this.points});
}

enum SelectedMode { strokeWidth, opacity, color }
