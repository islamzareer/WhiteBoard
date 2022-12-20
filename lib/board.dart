import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:white_board/custom_widgets/custom_floatingAction_button.dart';
import 'package:whiteboard/whiteboard.dart';

class Board extends StatefulWidget {
  const Board({super.key});
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  Color selectedColor = Colors.black;
  late Color pickerColor = Colors.blue;
  double strokeWidth = 3.0;
  bool showBottomList = false;

  late WhiteBoardController _controller;
  @override
  void initState() {
    _controller = WhiteBoardController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whiteboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Whiteboard'),
          actions: [
            IconButton(
                icon: const Icon(Icons.image),
                onPressed: _controller.convertToImage),
          ],
        ),
        body: Stack(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: WhiteBoard(
                      controller: _controller,
                      strokeWidth: strokeWidth,
                      //backgroundColor: Colors.black,
                      strokeColor: selectedColor,
                      onConvertImage: (Uint8List imageList) async {
                        await FileSaver.instance.saveAs(
                            "resultImage", imageList, 'png', MimeType.PNG);
                      }),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5, bottom: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomFloatingActionButton(
                            tag: 0,
                            function: () {
                              setState(() {
                                selectedColor = Colors.black;
                              });
                            },
                            icon: const Icon(FontAwesomeIcons.pen),
                          ),
                          const SizedBox(height: 2),
                          CustomFloatingActionButton(
                            tag: 1,
                            function: _controller.undo,
                            icon: const Icon(FontAwesomeIcons.arrowRotateLeft),
                          ),
                          const SizedBox(height: 2),
                          CustomFloatingActionButton(
                            tag: 2,
                            function: _controller.redo,
                            icon: const Icon(FontAwesomeIcons.arrowRotateRight),
                          ),
                          const SizedBox(height: 2),
                          CustomFloatingActionButton(
                            tag: 3,
                            function: () {
                              setState(() {
                                selectedColor = Colors.white;
                              });
                            },
                            icon: const Icon(FontAwesomeIcons.eraser),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Visibility(
                                visible: showBottomList,
                                child: Slider(
                                    value: strokeWidth,
                                    max: 50.0,
                                    min: 0.0,
                                    onChanged: (val) {
                                      setState(() {
                                        strokeWidth = val;
                                      });
                                    }),
                              ),
                              CustomFloatingActionButton(
                                tag: 4,
                                function: () {
                                  setState(() {
                                    showBottomList = !showBottomList;
                                  });
                                },
                                icon: const Icon(FontAwesomeIcons
                                    .upRightAndDownLeftFromCenter),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          CustomFloatingActionButton(
                            tag: 5,
                            function: () {
                              showColorPacker(context);
                            },
                            icon: const Icon(FontAwesomeIcons.palette),
                          ),
                          const SizedBox(height: 2),
                          CustomFloatingActionButton(
                            tag: 6,
                            function: _controller.clear,
                            icon: const Icon(FontAwesomeIcons.trash),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<dynamic> showColorPacker(BuildContext context) {
    return showDialog(
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
  }
}
