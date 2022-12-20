import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  Icon icon;
  Function()? function;
  int tag;
  CustomFloatingActionButton({
    required this.tag,
    required this.icon,
    required this.function,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btn$tag",
      onPressed: function,
      child: icon,
    );
  }
}
